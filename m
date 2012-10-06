Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab2JFRxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 13:53:07 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:5532 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2JFRxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 13:53:05 -0400
From: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [REGRESSION] Kernel 3.6 drops network packets instead of
 forwarding
Thread-Topic: [REGRESSION] Kernel 3.6 drops network packets instead of
 forwarding
Thread-Index: AQHNo8n+Cnn7F97uOUmjEh1tUpyi3ZesjgDw
Date: Sat, 6 Oct 2012 17:52:06 +0000
Message-ID: <B3A09DD14C7DC341B8B4D309FE5DD1BE1513FAA4@G2W2525.americas.hpqcorp.net>
In-Reply-To: <1349531616.21172.1069.camel@edumazet-glaptop>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.49.26]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Looks like the bug fixed by : 
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=f4ef85bbda96324785097356336bc79cdd37db0a
>
> (David Miller will send it to stable team shortly)

Yes, you are right. Applied the patch and it fixes the problem.
Thanks a lot for your help.

Regards
        Georg Chini



