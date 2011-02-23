Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1BWVQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:16:33 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:33189 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752535Ab1BWVQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:16:32 -0500
Message-ID: <4D65792C.8070703@tlinx.org>
Date: Wed, 23 Feb 2011 13:16:28 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: starting >=2.6.36 FATAL: Setup length exceeds 31 maximum; kernel setup will overwrite boot loader
X-Stationery: 0.4.10
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fatal: Setup length exceeds 31 maximum; kernel setup will overwrite
boot loader

Starting with 2.6.36, I started getting the above message.

It didn't seem what options I pruned out of the kernel
ipv6 support, iptables support, any thing I could think of
that would be a 'large chunk of space', nothing would make
it "fit" the way 2.6.35 did.

I didn't turn on options from options from 2.6.35 -> 2.6.36,
but did turn on things like BIOS blk throttling which seemed
low cost.  I set the lower BIOS reserved amount to 4K, which
seemed to be the default under the old system (?), though
this system hasn't ever been tested w/standby or hibernate
so don't know if this is a correct setting, but is unlikely relevant.

So where did this extra length come from?

I *hoped* it was a fluke w/26.36, that would disappear in 26.37...but
nep.  In searching for causes I saw one message pointing to the
XEN subsystem, but I made sure to remove that on both setups and that
made no difference.

So what's caused the sudden bump and how do I get around it?







