Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab1G3EIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 00:08:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61156 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1G3EIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 00:08:39 -0400
Subject: Re: [PATCH] sunrpc: use better NUMA affinities
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: NeilBrown <neilb@suse.de>, Greg Banks <gnb@fastmail.fm>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20110729234857.GA30941@fieldses.org>
References: <1311921035.7845.10.camel@edumazet-laptop>
	 <4E3258E1.6020000@fastmail.fm> <20110729103634.GA12050@infradead.org>
	 <5933F48C-49D6-492D-AB7B-B76A3ADDB6C6@fastmail.fm>
	 <1311941491.2843.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <F67B6E82-9FA8-464E-B3FB-DC0D4EC18BB0@fastmail.fm>
	 <20110729164836.GL23194@fieldses.org> <20110729165345.GM23194@fieldses.org>
	 <F562C6F4-3FC2-4952-A903-8E87E9EF2D9D@fastmail.fm>
	 <20110730093025.716f3f50@notabene.brown>
	 <20110729234857.GA30941@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jul 2011 06:08:34 +0200
Message-ID: <1311998914.2873.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 juillet 2011 à 19:48 -0400, J. Bruce Fields a écrit :
> On Sat, Jul 30, 2011 at 09:30:25AM +1000, NeilBrown wrote:
> > 
> > rpc.nfsd 0
> > 
> > will stop all nfsd threads.  Follow with
> > 
> >   exportfs -f
> > 
> > and you should be done.  I'm not 100% sure about the nfsv4 thread though -
> > would need to check.
> 
> Should be fine.
> 

What are the needed steps to be able to unload nfsd module ?

So far, I am unable to perform this without using -f option.





