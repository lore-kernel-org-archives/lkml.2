Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2DYRnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:43:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51293 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2DYRnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:43:06 -0400
Subject: Re: many rx packets dropped since 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris <xchris89x@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAOFJUki3Jg+fAWWY70nDUCdxVs5A5VGfwkwUn01a4BX+N5nm-A@mail.gmail.com>
References: <CAOFJUkhi6NoECFGcz=rq8-uVXFc90V4SuH=A1+sWdvYDDhO8Ow@mail.gmail.com>
	 <1335353427.3274.103.camel@edumazet-glaptop>
	 <CAOFJUkj27aF6diDjcZFTyBaTdDdU8URkj+1vr3ECoozbzqDVBg@mail.gmail.com>
	 <1335357975.3274.187.camel@edumazet-glaptop>
	 <CAOFJUki3Jg+fAWWY70nDUCdxVs5A5VGfwkwUn01a4BX+N5nm-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Apr 2012 19:43:01 +0200
Message-ID: <1335375781.5951.2.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 16:38 +0200, Chris wrote:
> 2012/4/25 Eric Dumazet <eric.dumazet@gmail.com>:
> >> Why do we see dropped packets only in virtual environments and bonded
> >> network interfaces and not on real network interfaces?
> >
> > This has to be investigated, eventually.
> 
> Do you have the opportunity to test it? Just install fedora 16 (linux
> 3.3) or ubuntu 12.04 (linux 3.2) as guest under kvm and use as virtual
> network card virtio_net or e1000.
> 
> You will see many lost rx packets and i have no idea why???


You can use drop_monitor / dropwatch to figure out

https://fedorahosted.org/dropwatch/

http://prefetch.net/blog/index.php/2011/07/11/using-netstat-and-dropwatch-to-observe-packet-loss-on-linux-servers/

Or just ignore the thing, if no user side effect is noticed.



