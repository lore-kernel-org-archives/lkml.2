Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab2FZRVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:21:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44389 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758524Ab2FZRVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:21:21 -0400
Date: Tue, 26 Jun 2012 18:21:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH] oprofile, perf: Use per-cpu framework
Message-ID: <20120626172109.GT27996@mudshark.cambridge.arm.com>
References: <1339168564-30008-1-git-send-email-will.deacon@arm.com>
 <20120615154359.GE12031@mudshark.cambridge.arm.com>
 <20120615161635.GV1478@erda.amd.com>
 <20120615161954.GF12031@mudshark.cambridge.arm.com>
 <20120622144231.GJ24632@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622144231.GJ24632@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 03:42:31PM +0100, Robert Richter wrote:
> Will,

Hi Robert,

> I just realized I wrote a patch some time ago that introduces per_cpu
> variables, see below. Please give it a try to, I will then queue it
> for v3.6.

Your patch seems fine with and without CONFIG_CPUMASK_OFFSTACK, so:

Acked-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will
