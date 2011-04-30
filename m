Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1D3Or5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:47:57 -0400
Received: from filoni2.nine.ch ([94.230.212.32]:58709 "EHLO mail.lenux.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab1D3Or4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 10:47:56 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Apr 2011 10:47:56 EDT
Message-ID: <4DBC1F2F.5050205@docs.homelinux.org>
Date: Sat, 30 Apr 2011 16:39:43 +0200
From: root <root@docs.homelinux.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kys@microsoft.com
Subject: Error in Hyper-V modules hv_vmbus
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I have compiled and installed the new 2.6.39-rc5 linux kernel with 
Microsoft Hyper-V modules enabled on my Debian Squeeze system. After a 
reboot I get these errors (sorry can post only screenshots because I 
can't copy the log):

http://docs.homelinux.org/hv

and system doesn't boot. What's wrong? I think modprobe can't load 
hv_vmbus?!?

Regards
Juan Dos Santos
