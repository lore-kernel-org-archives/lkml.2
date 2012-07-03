Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab2GCNNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:13:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60308 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab2GCNNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:13:45 -0400
Subject: Re: Linux 3.5-rc5
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andreas Herz <andi@geekosphere.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20120703123855.GM9358@workstation>
References: <CA+55aFws_u8A7tm8abOmnDe_orUY7LnjWpJwYzgXndvjoXRW8w@mail.gmail.com>
	 <20120703123855.GM9358@workstation>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Jul 2012 15:13:41 +0200
Message-ID: <1341321221.2583.358.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 14:38 +0200, Andreas Herz wrote:
> On 30/06/12 at 16:55, Linus Torvalds wrote:
> > Eric Dumazet (5):
> >       net: remove skb_orphan_try()
> 
> Finally it's gone. Came with 2.6.35 and since then several weird issues
> occured with some network applications. For example openswan was broken
> as skb_orphan_try removed the skb->sk too soon and pakets with
> fragmentation got lost/couldn't be determined.
> 

Thanks for your great active feedback on this problem.


