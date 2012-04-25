Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab2DYLao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:30:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54970 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab2DYLam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:30:42 -0400
Subject: Re: many rx packets dropped since 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris <xchris89x@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAOFJUkhi6NoECFGcz=rq8-uVXFc90V4SuH=A1+sWdvYDDhO8Ow@mail.gmail.com>
References: <CAOFJUkhi6NoECFGcz=rq8-uVXFc90V4SuH=A1+sWdvYDDhO8Ow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Apr 2012 13:30:27 +0200
Message-ID: <1335353427.3274.103.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 13:03 +0200, Chris wrote:
> Hello,
> 
> There is a bug since 2.6.37 with dropped rx packets in virtual
> environments (like kvm) and bonded network interfaces.
> 
> References:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/890475
> https://bugzilla.redhat.com/show_bug.cgi?id=709551
> 
> This change has led to:
> commit caf586e5f23cebb2a68cbaf288d59dbbf2d74052
> Author: Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Thu Sep 30 21:06:55 2010 +0000
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=caf586e5f23cebb2a68cbaf288d59dbbf2d74052
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8990f468a
> 
> Would it be possible to remove this patch?
> 
> --
> Chris

Its no possible to remove this patch.

If you want to ignore fact that packets _are_ dropped, just ignore the
counter.

We want to track dropped packets, not hide them.



