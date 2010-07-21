Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0GUMvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:51:43 -0400
Received: from smtp1.hushmail.com ([65.39.178.133]:37053 "EHLO
	smtp11.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0GUMvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:51:42 -0400
X-Hush-Verified-Domain: hushmail.com
MIME-Version: 1.0
Date: Wed, 21 Jul 2010 15:51:39 +0300
To: maciej.rutecki@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: netfilter/iptables stopped logging 2.6.35-rc
From: auto401300@hushmail.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20100721125139.4CC3C1200A6@smtp.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Jul 2010 15:51:03 +0300 Maciej Rutecki 
<maciej.rutecki@gmail.com> wrote:
>On sobota, 17 lipca 2010 o 09:20:36 auto401300@hushmail.com wrote:
>> Hi!
>> 
>> Has something broken with netfilter/iptables logging in 2.6.35-
>rc,
>> or is there something new I should set in .config since .34?
>> 
>> 
>> I just verified that if I boot .34 and ping the pc it does 
>logging:
>> 
>> Jul 17 09:42:49 xxxxx kernel: Linux version 2.6.34-ab 
>(root@xxxxx)
>> (gcc version 4.4.4 (Debian 4.4.4-1) ) #1 SMP PREEMPT Mon May 17
>> 09:15
>> 
>> :15 EEST 2010
>> 
>> ....
>> Jul 17 09:44:52 xxxxx kernel: DENY  in: IN=eth0 OUT= MAC=xxxxx
>> SRC=xxxxx DST=xxxxx LEN=60 TOS=0x00 PREC=0x00 TTL=127 ID=38945
>> PROTO=ICMP TYPE=8 CODE=0 ID=512 SEQ=256
>> 
>> 
>> but if I boot .35-rc4 and ping:
>> 
>> Jul 17 09:48:08 xxxxx kernel: Linux version 2.6.35-rc4-aa
>> (root@xxxxx) (gcc version 4.4.4 (Debian 4.4.4-6) ) #1 SMP 
>PREEMPT
>> Mon Jul 5 15:22:02 EEST 2010
>> ....
>> nothing from iptables in log
>> 
>> 
>> userspace is same, only booted different kernel versions
>
>I created a Bugzilla entry at 
>https://bugzilla.kernel.org/show_bug.cgi?id=16423
>for your bug report, please add your address to the CC list in 
>there, thanks!
>
>-- 
>Maciej Rutecki
>http://www.maciek.unixy.pl




Verified now with debian kernel-package 12.036

2.6.34 does netfilter/iptables logging
2.6.35-rc5 does not
both compiled with same toolchain



thanks. 

