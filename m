Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1CYO01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:26:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56796 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1CYO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:26:26 -0400
Message-ID: <4D8CA60C.9090100@monstr.eu>
Date: Fri, 25 Mar 2011 15:26:20 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/2] microblaze: Final irq bits for .39
References: <20110325134935.999574075@linutronix.de>
In-Reply-To: <20110325134935.999574075@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thomas Gleixner wrote:
> Michal,
> 
> the following patches convert to the new irq function names and make
> use of the generic show_interrupts().

I will test them next week and let you know.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
