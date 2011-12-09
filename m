Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1LIJRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:17:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1LIJRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:17:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.00.1112091505010.20839@tundra.namei.org>
References: <alpine.LRH.2.00.1112091505010.20839@tundra.namei.org> <28442.1323269262@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [GIT PULL] Crypto keys and module signing
Date: Fri, 09 Dec 2011 09:17:33 +0000
Message-ID: <2409.1323422253@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > Could you pull my module signing code into the security tree?  The patches can
> > be viewed here:
> 
> I'm getting this build error:
> 
> make[1]: *** No rule to make target `kernel.pub', needed by 
> `kernel/modsign-pubkey.o'.  Stop.

If you turn module signing on, you have to supply keys for it to sign things
with and to later verify the signature...

I wonder what the best way to deal with that is...  I guess make allyesconfig
and make allmodconfig are going to break otherwise.

David
