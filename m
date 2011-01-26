Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1AZNBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:01:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab1AZNBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:01:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1296042734.10455.45.camel@localhost.localdomain>
References: <1296042734.10455.45.camel@localhost.localdomain> <1295887497-20198-4-git-send-email-roberto.sassu@polito.it> <1295887497-20198-1-git-send-email-roberto.sassu@polito.it> <5936.1296039791@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, Roberto Sassu <roberto.sassu@polito.it>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Subject: Re: [RFC][PATCH v3 3/6] encrypted-keys: add key format support
Date: Wed, 26 Jan 2011 13:01:17 +0000
Message-ID: <9974.1296046877@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Either way it is extensible.  The current format is:
> 
> keyctl add encrypted name "new [format] key-type:master-key-name keylen" ring
> 
> As none of the other encrypted key parameters are defined as keypairs,
> I'd prefer leaving the format option as it is.

Okay.  Feel free to add my Acked-by then.

David
