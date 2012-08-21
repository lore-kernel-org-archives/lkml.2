Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2HUNq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:46:58 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56711 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2HUNqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:46:54 -0400
MIME-Version: 1.0
In-Reply-To: <5032D0C0.4080908@oak.selfip.net>
References: <502ECC74.9030605@oak.selfip.net>
	<20120819042543.GA14461@digium.com>
	<20120819082117.GA4634@thinkpad.lan>
	<5032D0C0.4080908@oak.selfip.net>
Date: Tue, 21 Aug 2012 09:46:53 -0400
Message-ID: <CADVnQykZv-VfScHSDkNXau1Pn765+fhyZOJce_R5uTbvmUCUpA@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at 00010016
From: Neal Cardwell <ncardwell@google.com>
To: Dave Haywood <tla@oak.selfip.net>
Cc: Artem Savkov <artem.savkov@gmail.com>, Shaun Ruffell <sruffell@digium.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 8:05 PM, Dave Haywood <tla@oak.selfip.net> wrote:
> Bisected to:
>
> 5d299f3d3c8a2fbc732b1bf03af36333ccec3130 is the first bad commit
>
> commit 5d299f3d3c8a2fbc732b1bf03af36333ccec3130
>
> Author: Eric Dumazet <edumazet@google.com>
>
> Date:   Mon Aug 6 05:09:33 2012 +0000
>
>     net: ipv6: fix TCP early demux

Yes, this is expected. There was a fix checked into the "net" tree yesterday:

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commitdiff;h=fae6ef87faeb8853896920c68ee703d715799d28

Please let us know if that doesn't fix the crashes for you.

thanks,
neal
