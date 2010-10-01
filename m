Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0JARFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:05:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59218 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab0JARFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:05:32 -0400
Subject: Re: [PATCH 0/5] oprofile updates for v2.6.37
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
References: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 18:05:05 +0100
Message-ID: <1285952705.31571.2.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2010 17:05:08.0752 (UTC) FILETIME=[CD467900:01CB618A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

On Fri, 2010-10-01 at 16:56 +0100, Robert Richter wrote:
> This patch set contains some rework and cleanups of the oprofile code.
> It also contains changes of the oprofile perf backend that is
> currently implemented for the ARM architecture, but will be ported to
> oprofile generic code.
> 
> Will, please ack the ARM changes if you are fine with it.
> 

I've been through patches 2, 3 and 4 and they look fine. I've also
tested them and can't see any regressions. Thanks for sticking with
this!

Acked-by: Will Deacon <will.deacon@arm.com>

Have a good weekend,

Will

