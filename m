Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab1DMBsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:48:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63199 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab1DMBsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:48:51 -0400
Message-ID: <4DA50102.8050900@keff.org>
Date: Wed, 13 Apr 2011 03:48:50 +0200
From: sh@keff.org
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Slow PCI-E speed
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Even if this is probably,even if I really think it's not, hardware
related I'm putting this question out there cause I have no idea on what
can be causing my problems.

Recently I've had the following cards in a HP DL145 G2

1x Myrinet 10G PCI-E 4x
2x Intel Quad 82546EB 1GE NIC
1x OCZ Revodrive 120GB

--

None of the cards above can deliver more than 375MB/s. The tests for the
Myrinet-card is done using multiple wgets. For the Intel Quads using
LACP and multiple wgets. The server I'm wget:ing from has shown
performance >=500Mbit/s in the past. And for the Revodrive using dd/cat.
Everything to /dev/null.

Because the DL145 G2 is quite old I thought it would be the chipsets etc
being the bottleneck.

I then replaced the server with a Supermicro X7DBE (2x E5405 CPUs with
13 GB Ram) which is based on a Intel 5000P Chipset. The Revodrive card
now sits in a dedicated PCI-E 4x slot connected to the 5000P chipset.
The other cards sits on an Intel ESB2-chipset connected with a 10.7GB/s
pipe to the 5000P (where the memory,cpu etc is).

The Revodrive should be able to handle ~500MB/s and well the Myrinet
~1000MB/s (atleast way more than 375MB/s). And the Intel Quads atleast
more than 375MB/s when bonded..

But everything tops out at 375MB/s. And yes..375 = 3Gbit/s :)

--

Like I said this probably isn't a Linux kernel problem but I want to
know if someone has come across something like this before and maybe
maybe...there's some kernel setting that fixes it cause i'm clueless.

Thanks!

// Sebastian H

