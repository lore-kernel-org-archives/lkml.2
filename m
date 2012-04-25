Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2DYOjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:39:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60154 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2DYOjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:39:00 -0400
MIME-Version: 1.0
In-Reply-To: <1335357975.3274.187.camel@edumazet-glaptop>
References: <CAOFJUkhi6NoECFGcz=rq8-uVXFc90V4SuH=A1+sWdvYDDhO8Ow@mail.gmail.com>
	<1335353427.3274.103.camel@edumazet-glaptop>
	<CAOFJUkj27aF6diDjcZFTyBaTdDdU8URkj+1vr3ECoozbzqDVBg@mail.gmail.com>
	<1335357975.3274.187.camel@edumazet-glaptop>
Date: Wed, 25 Apr 2012 16:38:59 +0200
Message-ID: <CAOFJUki3Jg+fAWWY70nDUCdxVs5A5VGfwkwUn01a4BX+N5nm-A@mail.gmail.com>
Subject: Re: many rx packets dropped since 2.6.37
From: Chris <xchris89x@googlemail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/25 Eric Dumazet <eric.dumazet@gmail.com>:
>> Why do we see dropped packets only in virtual environments and bonded
>> network interfaces and not on real network interfaces?
>
> This has to be investigated, eventually.

Do you have the opportunity to test it? Just install fedora 16 (linux
3.3) or ubuntu 12.04 (linux 3.2) as guest under kvm and use as virtual
network card virtio_net or e1000.

You will see many lost rx packets and i have no idea why???

--
Chris
