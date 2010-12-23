Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0LWReT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:34:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab0LWReO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:34:14 -0500
Date: Thu, 23 Dec 2010 12:34:02 -0500
From: Dave Jones <davej@redhat.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Youquan Song <youquan.song@intel.com>, cpufreq@vger.kernel.org,
        venki@google.com, arjan@linux.intel.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 0/6] cpufreq: Add sampling window to enhance ondemand
 governor power efficiency
Message-ID: <20101223173402.GA3821@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Youquan Song <youquan.song@intel.com>, cpufreq@vger.kernel.org,
	venki@google.com, arjan@linux.intel.com, lenb@kernel.org,
	suresh.b.siddha@intel.com, kent.liu@intel.com,
	chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	Youquan Song <youquan.song@linux.intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
 <20101223110020.GC18363@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223110020.GC18363@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:00:20PM +0100, Dominik Brodowski wrote:
 > Interesting approach, but seems to be quite different from what "ondemand"
 > does at the moment. And, as David Niemi pointed out, it seems to be more
 > Intel-specific. Therefore, what do you think about adding this different
 > algorithm as a different governor, and keep the "ondemand" algorithm more or
 > less as it is?

I'm hesitant to merge more governors. (We already have too many imo).
The userspace logic for automatically deciding which is the best one to use is
already pretty hairy, so any additional ones at this point would have to be
accompanied with some really compelling reasons why the existing ones can't
be fixed in an acceptable manner.

	Dave

