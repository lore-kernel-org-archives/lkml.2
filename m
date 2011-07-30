Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1G3GXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 02:23:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39307 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1G3GXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 02:23:16 -0400
Subject: Re: [PATCH] sunrpc: use better NUMA affinities
From: Eric Dumazet <eric.dumazet@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Greg Banks <gnb@fastmail.fm>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20110730160610.0b751ffd@notabene.brown>
References: <1311921035.7845.10.camel@edumazet-laptop>
	 <4E3258E1.6020000@fastmail.fm> <20110729103634.GA12050@infradead.org>
	 <5933F48C-49D6-492D-AB7B-B76A3ADDB6C6@fastmail.fm>
	 <1311941491.2843.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <F67B6E82-9FA8-464E-B3FB-DC0D4EC18BB0@fastmail.fm>
	 <20110729164836.GL23194@fieldses.org> <20110729165345.GM23194@fieldses.org>
	 <F562C6F4-3FC2-4952-A903-8E87E9EF2D9D@fastmail.fm>
	 <20110730093025.716f3f50@notabene.brown>
	 <20110729234857.GA30941@fieldses.org>
	 <1311998914.2873.27.camel@edumazet-laptop>
	 <20110730160610.0b751ffd@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jul 2011 08:23:10 +0200
Message-ID: <1312006990.2873.75.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 30 juillet 2011 à 16:06 +1000, NeilBrown a écrit :
> umount /proc/fs/nfsd
> 
> 

Thans  a lot, this was the thing I missed !



