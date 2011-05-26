Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab1EZSTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:19:34 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:42839 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1EZSTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:19:33 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DDE99A9.60401@elektron.elka.pw.edu.pl>
Date: Thu, 26 May 2011 20:19:21 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Wrong (0777) permissions on root filesystem after booting the kernel
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today I've stated, that in my laptop the root filesystem is mounted with 
very dangerous 0777 permissions. I've checked my other machines, and 
stated that in total 3 machines behave correctly (0755) and 2
mount / with permissions 0777.

Trying to find the cause, I've stated that it is not associated with 
initialization scripts, as booting with "init=/bin/bash" also leads to 
situation, where in one machine permissions are set to 0777, while in 
the another one, they are set to 0755.

The problem is not associated with the initrd, as it appears also when 
booting machine with kernel without initrd.

I've investigated settings of the bootloader (grub), but there is
no visible difference between affected and correctly working machines.

What information is used by the kernel to set permissions when mounting 
the root filesystem?
How does it depend on particular machine?
-- 
TIA & Regards,
Wojtek
