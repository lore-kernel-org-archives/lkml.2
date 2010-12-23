Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0LWVIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:08:55 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:49031 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751418Ab0LWVIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:08:53 -0500
Date: Thu, 23 Dec 2010 21:51:48 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Dave Jones <davej@redhat.com>, Youquan Song <youquan.song@intel.com>,
        cpufreq@vger.kernel.org, venki@google.com, arjan@linux.intel.com,
        lenb@kernel.org, suresh.b.siddha@intel.com, kent.liu@intel.com,
        chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 0/6] cpufreq: Add sampling window to enhance ondemand
 governor power efficiency
Message-ID: <20101223205148.GB6441@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Dave Jones <davej@redhat.com>,
	Youquan Song <youquan.song@intel.com>, cpufreq@vger.kernel.org,
	venki@google.com, arjan@linux.intel.com, lenb@kernel.org,
	suresh.b.siddha@intel.com, kent.liu@intel.com,
	chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	Youquan Song <youquan.song@linux.intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
 <20101223110020.GC18363@comet.dominikbrodowski.net>
 <20101223173402.GA3821@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223173402.GA3821@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Dec 23, 2010 at 12:34:02PM -0500, Dave Jones wrote:
> On Thu, Dec 23, 2010 at 12:00:20PM +0100, Dominik Brodowski wrote:
>  > Interesting approach, but seems to be quite different from what "ondemand"
>  > does at the moment. And, as David Niemi pointed out, it seems to be more
>  > Intel-specific. Therefore, what do you think about adding this different
>  > algorithm as a different governor, and keep the "ondemand" algorithm more or
>  > less as it is?
> 
> I'm hesitant to merge more governors. (We already have too many imo).

AFAICS, we do have two in-kernel dynamic frequency scaling governors, one of
which doesn't seem to get much usage (conservative)...

> The userspace logic for automatically deciding which is the best one to use is
> already pretty hairy, so any additional ones at this point would have to be
> accompanied with some really compelling reasons why the existing ones can't
> be fixed in an acceptable manner.

Well, if the underlying alogrithm is fundamentally different -- such as when
looking at sampling windows instead of the past one window -- this seems to
be a "compelling" reason to me. Especially if one governor works well on
certain platforms, and the other one works better on other platforms.

Best,
	Dominik
