Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1FEBu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 21:50:26 -0400
Received: from science.horizon.com ([71.41.210.146]:45807 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754900Ab1FEBuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 21:50:25 -0400
Date: 4 Jun 2011 21:50:23 -0400
Message-ID: <20110605015023.9860.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: andi@firstfloor.org, linux@horizon.com
Subject: Re: How to measure enable_kernel_fpu overhead?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110605003118.GP27166@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Different CPU models. This years CPUs does this and next years that.

Er, yes, exactly.  That's why we have multiple code paths, and
run-time selection of the best.  The basic principle is used rather
a lot in the Linux kernel, e.g. the alternative() feature.

To me the closest equivalent is the RAID6 code, which has no less than 12
different versions (5 integer, 4 AltiVec, 1 MMX, 1 SSE1, and 1 SSE2),
and on x86 it benchmarks the 8 different versions at boot time and
chooses the best.

What confuses me is:
> I would suggest KISS.

This suggestion is not quite clear to me; I'm not quite sure what you
think is "simple".  Do you mean always use the integer code and ignore
the SSE registers?  Or something else?

Could you expand on that remark a little, please?

Thank you!
