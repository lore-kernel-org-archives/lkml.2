Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1GCNif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:38:35 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:45349 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1GCNie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:38:34 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: RKK <kulkarni.ravi4@gmail.com>
Subject: Re: Linux 3.0-rc5 doesnt boot and hangs at rcu_sched_state ()
Date: Sun, 3 Jul 2011 15:38:30 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <BANLkTikW6Xk8UMsOHLCnLn7STRzy8RaiJA@mail.gmail.com>
In-Reply-To: <BANLkTikW6Xk8UMsOHLCnLn7STRzy8RaiJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107031538.30379.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 29 czerwca 2011 o 15:26:35 RKK wrote:
> Hello,
> I tried booting Linux3.0.rc5 on my machine today but everytime it
> hangs after this message
> 
> a)starting configure read only root support
> 
> after this waiting for sometime then this message appears
> 
> b)INFO rcu_sched_state: RCU stalls CPU/disks
> 
> i tried to read the Documentation/RCU and enable CONFIG_RCU_TRACE but
> dint know how to proceed further  .
> 
> i tried repeating this 4-5 times , one thing i observed that is
> appearance of rcu_sched_state is intermittent but everytime the boot
> stops/hangs at a) message .
> 
> 
> the same config works on 2.6.39.2  .
> im using Fedora 15 and im attaching config file for reference . If u
> want any other info in which i can help let me know how to do it.
> thanks.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=38732
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
