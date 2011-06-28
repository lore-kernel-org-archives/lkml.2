Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab1F1N7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 09:59:40 -0400
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:34627 "EHLO mfo.iij4u.or.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756146Ab1F1N5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:57:31 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jun 2011 09:57:30 EDT
Date: Tue, 28 Jun 2011 22:47:43 +0900 (JST)
Message-Id: <20110628.224743.75173118873131581.masm.nn@mbox.iij4u.or.jp>
To: linux-kernel@vger.kernel.org
Subject: a file of wireshark corrupted when installation.
From: Yuuki Harano <masm@flowernet.gr.jp>
Organization: Personal User of IIJ4U.
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I don't subscribe to this list, so please CC to me.

When I install wireshark on kernel 2.6.39.*, libwiretap.so is filled by 0.
libwiretap.so in compilation work is no problem.
When 2.6.38.*, no problem. And when I make and installed libwiretap.so
on 2.6.39.* slowly by hands, also no problem.

thinkpad x61
slackware64 13.37
gcc 4.5.2
glibc 2.13
wireshark 1.4.5-1.6.0
ginstall
 install (GNU coreutils) 8.11

GNU ld (Linux/GNU Binutils) 2.21.51.0.6.20110118
  Supported emulations:
   elf_x86_64
   elf32_x86_64
   elf_i386
   i386linux
   elf_l1om

od -tx1 of broken libwiretap.so.0.0.1:
 0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
 4103360

-- masm
