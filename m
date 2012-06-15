Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2FOQT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:19:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49408 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932241Ab2FOQT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:19:57 -0400
Date: Fri, 15 Jun 2012 17:19:54 +0100
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] oprofile: perf: use NR_CPUS instead or nr_cpumask_bits
 for static array
Message-ID: <20120615161954.GF12031@mudshark.cambridge.arm.com>
References: <1339168564-30008-1-git-send-email-will.deacon@arm.com>
 <20120615154359.GE12031@mudshark.cambridge.arm.com>
 <20120615161635.GV1478@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615161635.GV1478@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 05:16:35PM +0100, Robert Richter wrote:
> On 15.06.12 16:43:59, Will Deacon wrote:
> > Given both the lack of feedback and the trivial nature of this patch would
> > you be able to pick this up please? I'd rather not push it via the ARM tree
> > as the change is under drivers/.
> 
> Will, I will apply it. Sorry for not responding earlier.

Great, thanks Robert.

Will
