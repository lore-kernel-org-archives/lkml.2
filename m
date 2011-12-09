Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1LIJfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:35:44 -0500
Received: from tundra.namei.org ([65.99.196.166]:34827 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab1LIJfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:35:42 -0500
Date: Fri, 9 Dec 2011 20:35:26 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan@linux.intel.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [GIT PULL] Crypto keys and module signing
In-Reply-To: <2409.1323422253@redhat.com>
Message-ID: <alpine.LRH.2.00.1112092034140.25197@tundra.namei.org>
References: <alpine.LRH.2.00.1112091505010.20839@tundra.namei.org> <28442.1323269262@redhat.com> <2409.1323422253@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > > Could you pull my module signing code into the security tree?  The patches can
> > > be viewed here:
> > 
> > I'm getting this build error:
> > 
> > make[1]: *** No rule to make target `kernel.pub', needed by 
> > `kernel/modsign-pubkey.o'.  Stop.
> 
> If you turn module signing on, you have to supply keys for it to sign things
> with and to later verify the signature...
> 
> I wonder what the best way to deal with that is...  I guess make allyesconfig
> and make allmodconfig are going to break otherwise.

Create a dummy key?


-- 
James Morris
<jmorris@namei.org>
