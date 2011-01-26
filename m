Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1AZLD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:03:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1AZLD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:03:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1295887497-20198-4-git-send-email-roberto.sassu@polito.it>
References: <1295887497-20198-4-git-send-email-roberto.sassu@polito.it> <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Subject: Re: [RFC][PATCH v3 3/6] encrypted-keys: add key format support
Date: Wed, 26 Jan 2011 11:03:11 +0000
Message-ID: <5936.1296039791@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Sassu <roberto.sassu@polito.it> wrote:

> This patch introduces a new parameter, called 'format', that defines the
> format of data stored by encrypted keys. The 'default' format identifies
> encrypted keys containing only the symmetric key, while other formats can
> be defined to support additional information. The 'format' parameter is
> written in the datablob produced by commands 'keyctl print' or
> 'keyctl pipe' and is integrity protected by the HMAC.

Would it make more sense to take key=val pairs where you have the <format>
parameter?  Then you could have a format=default|foo|whatever argument and
you'd leave room for future addition of qualifiers.

David
