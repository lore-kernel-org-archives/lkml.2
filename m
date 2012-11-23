Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2KWOKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:10:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60285 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2KWOKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:10:33 -0500
Date: Fri, 23 Nov 2012 15:10:25 +0100
From: Robert Richter <rric@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Maynard Johnson <maynardj@us.ibm.com>,
        "jgq516@gmail.com" <jgq516@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: oprofile: add A5/A7/A15 entries in op_perf_name
Message-ID: <20121123141025.GG24690@rric.localhost>
References: <1351853016-4476-1-git-send-email-jgq516@gmail.com>
 <20121105113102.GF3351@mudshark.cambridge.arm.com>
 <20121120121747.GJ2504@rric.localhost>
 <20121120155717.GD26475@mudshark.cambridge.arm.com>
 <20121120163158.GO2504@rric.localhost>
 <20121120165517.GC27765@mudshark.cambridge.arm.com>
 <20121120170601.GR2504@rric.localhost>
 <20121120170817.GG27765@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120170817.GG27765@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.11.12 17:08:17, Will Deacon wrote:
> > The advantage of a solution where userland updates cpu_type is that we
> > never need to update the kernel anymore. This means, cpu detection can
> > be part of the tools.
> 
> True, but the kernel-side perf code still needs updating to support the new
> CPU so I don't think you win much.

You also need perf support to use operf. If oprofile can update
cpu_type, the oprofile kernel interface would work for new hardware
without changes. We have support for both then, operf and opcontrol.

-Robert


