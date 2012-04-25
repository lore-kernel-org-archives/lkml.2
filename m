Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2DYMet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:34:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34035 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2DYMer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:34:47 -0400
MIME-Version: 1.0
In-Reply-To: <1335353427.3274.103.camel@edumazet-glaptop>
References: <CAOFJUkhi6NoECFGcz=rq8-uVXFc90V4SuH=A1+sWdvYDDhO8Ow@mail.gmail.com>
	<1335353427.3274.103.camel@edumazet-glaptop>
Date: Wed, 25 Apr 2012 14:34:45 +0200
Message-ID: <CAOFJUkj27aF6diDjcZFTyBaTdDdU8URkj+1vr3ECoozbzqDVBg@mail.gmail.com>
Subject: Re: many rx packets dropped since 2.6.37
From: Chris <xchris89x@googlemail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/25 Eric Dumazet <eric.dumazet@gmail.com>:
> On Wed, 2012-04-25 at 13:03 +0200, Chris wrote:
>> Hello,
>>
>> There is a bug since 2.6.37 with dropped rx packets in virtual
>> environments (like kvm) and bonded network interfaces.
>>
>> References:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/890475
>> https://bugzilla.redhat.com/show_bug.cgi?id=709551
>>
>> This change has led to:
>> commit caf586e5f23cebb2a68cbaf288d59dbbf2d74052
>> Author: Eric Dumazet <eric.dumazet@gmail.com>
>> Date:   Thu Sep 30 21:06:55 2010 +0000
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=caf586e5f23cebb2a68cbaf288d59dbbf2d74052
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8990f468a
>>
>> Would it be possible to remove this patch?
>>
>> --
>> Chris
>
> Its no possible to remove this patch.
>
> If you want to ignore fact that packets _are_ dropped, just ignore the
> counter.
>
> We want to track dropped packets, not hide them.

Are you sure that these packets are really dropped? I see a lot of
more packets dropped with virtio_net instead of e1000. (KVM
environments)

Why do we see dropped packets only in virtual environments and bonded
network interfaces and not on real network interfaces?

--
Chris
