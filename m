Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2BVEMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 23:12:45 -0500
Received: from nm19.bullet.mail.bf1.yahoo.com ([98.139.212.178]:37367 "HELO
	nm19.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932117Ab2BVEMo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 23:12:44 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 596854.93472.bm@omp1012.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YR55dxjqXsnLDqPNnsDmynlbXUFhYLpl41EUvOKqclHCmGvzR7Vs9m+wFBp/vYNBYx2dswFaF3VYo+e3L1FXiSJvKbO8jokcd3Msg3nw6ic12JfH8HuWx2tsGrFiAVHXEmcY6A8o7sMUIDHtNiNiespkhYdnMshVqA2zfHCzV+M=;
X-YMail-OSG: 7hPe8uoVM1nOwLQIB_TTPUJice3Z8C8nTFDklAfUfiAm5KI
 d69XGBsBaD4BZw7JMWJZ49NjXRHoiJILsteJS_tyISqMU5LiEHV3vgc210dh
 2EbDbLi0q6PIhUSR_nUxvupCMlfucfx4DOQDvNEjuD1nJy5B5b.PKcUBR2Id
 5WWsU1bg3kH7b_QMu6_2ZKL9i4vDLEkSLtLQKfMu6dYC7QduwwB_jTHenewL
 50XwK17ugp2RuJJXJgeE23MZUGdOICzwIjyc2aIDfcdMY5KvvUDP.loRvmxm
 CGlatIKJCgbWEnXRcXVEcEz3riPumkjGquThGf_HgHY0cQ0ycpmi4HekPhtB
 Z5jw5UcfQuv24r_Dg24mapN.m3scaGiQHb_d5fwgUAB3NnDReuo2BjHGcrDC
 la.7K59ZX4PjKnF8IXCjwEZbyaexyzDuiOyvju3nftimObL7Ke.rYMBSpC2N
 yRFEW_OVJmFS4EPOPJMvO1VQhBZzdUQ--
X-Mailer: YahooMailWebService/0.8.116.338427
Message-ID: <1329883963.92930.YahooMailNeo@web162006.mail.bf1.yahoo.com>
Date: Tue, 21 Feb 2012 20:12:43 -0800 (PST)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: [HELP REQUIRED] : Andorid FIQ Debugger Porting issue on Kernel2.6.36 
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Dear All,

This is regarding Android FIQ Debugger porting for another Linux mobile with kernel2.6.36.
I have successfully ported the fiq_debugger.c, fiq_glue.S and others and resolved the compilation issues.
I have enabled all the configs as below:
CONFIG_FIQ=y
CONFIG_FIQ_GLUE=y
CONFIG_FIQ_DEBUGGER=y
CONFIG_FIQ_DEBUGGER_NO_SLEEP=y
CONFIG_FIQ_DEBUGGER_WAKEUP_IRQ_ALWAYS_ON=y
CONFIG_FIQ_DEBUGGER_CONSOLE=y

But when I load the kernel on the device, the fiq handler is not getting called after I press ENTER key many times during the following prompt.
<hit enter to activate fiq debugger>
---
---

As per the current analysis the "debug_fiq" handler is not getting called. It is supposed to be called from the "fiq_glue.S" assembly code.

What could be the problem?

If somebody knows about FIQ debugger please give some pointer.


Thanks, Regards,
Pintu
