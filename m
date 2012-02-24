Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab2BXOL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:11:28 -0500
Received: from info.elf.stuba.sk ([147.175.111.14]:2075 "EHLO
	info.elf.stuba.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab2BXOL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:11:27 -0500
From: fodrek@kasr.elf.stuba.sk
To: linux-kernel@vger.kernel.org
Subject: KGDB over Ethternet howto patch
Date: Fri, 24 Feb 2012 11:46:10 +0100
Message-ID: <2246514.qxdvR2DpWZ@fodrek.kar.elf.stuba.sk>
User-Agent: KMail/4.8.0 (Linux/3.1.9-1.4-desktop; KDE/4.8.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned: by AntiVirus filter AVilter (msg.Pj11VeW3@mail2.elf.stuba.sk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux kernel developpers,

I would like to ask you how to debug linux kernel over etherent.
We are designing aplication usaig RTAI (Hard realtime extension using kenrel 
patch too) and we have been found some problems in our Linux kernel module.

This module serves a hard realime RTAI application and we are to debug it 
using Ethernet insatead of RS232/RS485 or other UART port as is  possible
out of box. We are familiar to use gdb as weel as for remote debuging of the 
usewr space application but not debuging kernel.

Excuse me if I am sending messige to the wrong mailing list, please?

I look forward hearing from you

Yours faithfully

Peter Fodrek
Institute of Control and Industrial Informatics
Faculty of Electrical Enginering and Information Technology
Slovak University of Technology at Bratislava
