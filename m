Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1G1Nqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:46:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60536 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab1G1Nqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:46:37 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Stephan Seitz <stse+lkml@fsing.rootsland.net>
Subject: Re: IP forwarding regression since 3.0-rc6
Date: Thu, 28 Jul 2011 15:46:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
In-Reply-To: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107281546.33227.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 25 lipca 2011 o 14:51:24 Stephan Seitz wrote:
> Hi!
> 
> Since 3.0-rc6 I see that my Linux router is losing packets. I can see
> them tracing the internal interface, but I don’t see them on the external
> interface. I can reproduce the problem while using tin with
> news.individual.de. At the startup when tin checks every newsgroup from
> the server, many packets are suddenly not routed anymore but are dropped,
> so tin hangs until it quits with a NNTP error.
> All kernels until 3.0-rc5 are working.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=40282
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
