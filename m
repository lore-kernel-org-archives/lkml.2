Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1GEKn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:43:58 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38794 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab1GEKn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:43:57 -0400
Message-ID: <4E12EAE9.2090305@monstr.eu>
Date: Tue, 05 Jul 2011 12:43:53 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 05/11] microblaze/irqs: Do not trace arch_local_{*,irq_*}
 functions
References: <20110702030435.308336775@goodmis.org> <20110702033853.617637031@goodmis.org>
In-Reply-To: <20110702033853.617637031@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
> Although they are marked inline, gcc may still make a function out of
> them and add it to the pool of functions that are traced by the function
> tracer. This can cause undesirable results (kernel panic, triple faults,
> etc).
> 
> Add the notrace notation to prevent them from ever being traced.
> 
> Cc: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Applied.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
