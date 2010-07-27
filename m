Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0G0Km6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:42:58 -0400
Received: from mail.agmk.net ([91.192.224.71]:34332 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025Ab0G0Km4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:42:56 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "Neil Brown" <neilb@suse.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 27 Jul 2010 12:42:57 +0200
Subject: Re: [2.6.34.1] OOPS in raid10 module.
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: =?utf-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
Message-ID: <op.vghz1vq1zu3k57@pawels.alatek.krakow.pl>
User-Agent: Opera Mail/10.60 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:

> Given the other oops message you included, I wonder if something is
> corrupting memory and md/raid10 is just getting caught in the cross-fire.
> It might be worth checking how you go at accessing all the etherd devices
> without use md.  Maybe just 26 'dd' commands in parallel writing to them,
> or reading from them.

thanks for hint!

i've discovered some weird and reproducible (for me) EFAULT during playing
with AoE on loopback interface. here'e the link to the testcase at  
AoE-discuss list:

http://sourceforge.net/mailarchive/forum.php?thread_name=op.vgggkbqxzu3k57%40pawels.alatek.krakow.pl&forum_name=aoetools-discuss

BR,
Pawel.
