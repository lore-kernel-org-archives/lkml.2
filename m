Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1AZLwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:52:40 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:50912 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1AZLwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:52:39 -0500
Subject: Re: [RFC][PATCH v3 3/6] encrypted-keys: add key format support
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
In-Reply-To: <5936.1296039791@redhat.com>
References: <1295887497-20198-4-git-send-email-roberto.sassu@polito.it>
	 <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
	 <5936.1296039791@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 06:52:14 -0500
Message-ID: <1296042734.10455.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 11:03 +0000, David Howells wrote:
> Roberto Sassu <roberto.sassu@polito.it> wrote:
> 
> > This patch introduces a new parameter, called 'format', that defines the
> > format of data stored by encrypted keys. The 'default' format identifies
> > encrypted keys containing only the symmetric key, while other formats can
> > be defined to support additional information. The 'format' parameter is
> > written in the datablob produced by commands 'keyctl print' or
> > 'keyctl pipe' and is integrity protected by the HMAC.
> 
> Would it make more sense to take key=val pairs where you have the <format>
> parameter?  Then you could have a format=default|foo|whatever argument and
> you'd leave room for future addition of qualifiers.
> 
> David

Either way it is extensible.  The current format is:

keyctl add encrypted name "new [format] key-type:master-key-name keylen" ring

As none of the other encrypted key parameters are defined as keypairs,
I'd prefer leaving the format option as it is.

thanks,

Mimi

