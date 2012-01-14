Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2ANATa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 19:19:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43930 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2ANAT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 19:19:29 -0500
MIME-Version: 1.0
In-Reply-To: <20120114000101.GL1068@n2100.arm.linux.org.uk>
References: <20120114000101.GL1068@n2100.arm.linux.org.uk>
Date: Fri, 13 Jan 2012 16:19:28 -0800
X-Google-Sender-Auth: hwv187YCpGHJYSwmG6y1Db23f7A
Message-ID: <CA+8MBbKhLWRrJCrHpn1iVCVUUmnpux+W+Yj7H20rp2dAX49xSA@mail.gmail.com>
Subject: Re: [BUG] vmstat reports no interrupts
From: Tony Luck <tony.luck@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 4:01 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> +               sum += kstat_cpu_irqs_sum(i);
> +               sum += arch_irq_stat_cpu(i);

It was broken on ia64 too - this patch fixes it.

Tested-by: Tony Luck <tony.luck@intel.com>
