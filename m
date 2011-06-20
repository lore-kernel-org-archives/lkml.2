Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1FTPK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:10:56 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:54270 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997Ab1FTPKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:10:51 -0400
Message-ID: <4DFF62F5.2080802@ti.com>
Date: Mon, 20 Jun 2011 20:40:45 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
References: <20110620095053.GA2082@n2100.arm.linux.org.uk> <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com> <20110620104415.GF2082@n2100.arm.linux.org.uk> <4DFF255E.5030308@ti.com> <20110620111336.GG2082@n2100.arm.linux.org.uk> <4DFF2E37.8030602@ti.com> <20110620114019.GH2082@n2100.arm.linux.org.uk> <20110620142338.GL2082@n2100.arm.linux.org.uk> <4DFF5F29.2000904@ti.com> <20110620150140.GM2082@n2100.arm.linux.org.uk>
In-Reply-To: <20110620150140.GM2082@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2011 8:31 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 20, 2011 at 08:24:33PM +0530, Santosh Shilimkar wrote:
>> I am away from my board now. Will test this change.
>> btw, the online-active race is still open even with this patch close
>> and should be fixed.
>
> I have yet to see any evidence of that race - I've been running your
> test loop for about an hour so far on Versatile Express and nothing
> yet.
>
In that case my script was just exposing the calibrate() code race
condition.

> That's not to say that we shouldn't wait for the active mask to become
> true before calling schedule(), but I don't think its as big a deal as
> you're suggesting it is.
I am not expert to really trigger that exact race online-to-active but
am sure the race needs to be fixed.

May be Thomas can suggest a test-case to expose that race. From
his fix for x86, it appeared that the race was indeed hit in some
sequence.

Regards,
Santosh

