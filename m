Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0LHKym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:54:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab0LHKyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:54:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1291762122.2680.31.camel@localhost.localdomain>
References: <1291762122.2680.31.camel@localhost.localdomain> <1290556535.2604.16.camel@localhost.localdomain> <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com> <4182.1291383725@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.5 5/5] keys: add new key-type encrypted
Date: Wed, 08 Dec 2010 10:54:24 +0000
Message-ID: <13657.1291805664@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > > +static struct key *request_trusted_key(const char *trusted_desc,
> > > +				       u8 **master_key,
> > > +				       unsigned int *master_keylen)
> > 
> > You need to annotate the function with an __acquires() to indicate that it
> > returns with a lock held for Sparse checking.  I think you should be able to
> > do:
> > 
> > 	__acquires(tkey->sem)
> 
> hm, only after addding '__acquires' are there Sparse errors.

Leave it, then.

David
