Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0ICStU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:49:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56940 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0ICStT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=u7/DV2KyIEExq3Eh/PeJ3KQ6u6ILKAfWJven0rcIm0ifF8CfJdHi52rv7ZqvN7ccvX
         V7tYP2CX2arNkBsukbew3kts3BR3J0pOq9FgLNmvE0Hb+dEUPF/HFj06K7YjNPHuwWtE
         ZORTMDdfWKhm9uoyMQ/dRTEqfAC9ltmTrjHRg=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Matthias Dahl <ml_kernel@mortal-soul.de>
Subject: Re: [2.6.35.x regression] rcu_preempt_state stall warning and machine slow-downs
Date: Fri, 3 Sep 2010 20:49:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201009010847.20236.ml_kernel@mortal-soul.de>
In-Reply-To: <201009010847.20236.ml_kernel@mortal-soul.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009032049.13830.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 1 września 2010 o 08:47:19 Matthias Dahl wrote:
> Hi.
> 
> I've a recurring problem w/ kernel 2.6.35.x that I cannot pinpoint exactly
> but seems to be related to rcu_preempt_state stall warnings I get
> frequently.
> 
> From time to time, the machine slows down to an almost halt (meaning jumpy
> or non-responsive mouse cursor, unable to switch to text console, ...)
> which can also result in a complete hang w/o any way to recover.  
> Sometimes the system catches up again but once this happened,  the system
> is sluggish and a reboot is required nevertheless. High load seems to help
> a lot to trigger this issue.
> 
> In every instance, I found stall warnings in my log which might be related.
> I have attached three of them along with my config and dmesg.
> 
> The system works flawlessly with pre-2.6.35 kernels-  no stall warnings and
> no slow-downs at all.
> 
> If there is anything I can do to help further diagnose this problem, please
> let me know.
> 
> So long,
> matthias.
> 
> PS. Please cc' me because I am not subscribed to the list. Thanks a lot.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=17732
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
