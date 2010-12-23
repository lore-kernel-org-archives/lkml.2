Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0LWOjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:39:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36732 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab0LWOjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:39:16 -0500
Date: Thu, 23 Dec 2010 14:38:59 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Youquan Song <youquan.song@intel.com>, davej@redhat.com,
        cpufreq@vger.kernel.org, venki@google.com, arjan@linux.intel.com,
        lenb@kernel.org, suresh.b.siddha@intel.com, kent.liu@intel.com,
        chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 6/6] cpufreq: Evaluate P1 before enter turbo mode
Message-ID: <20101223143859.GA1402@srcf.ucam.org>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com> <1293085424-18212-2-git-send-email-youquan.song@intel.com> <1293085424-18212-3-git-send-email-youquan.song@intel.com> <1293085424-18212-4-git-send-email-youquan.song@intel.com> <1293085424-18212-5-git-send-email-youquan.song@intel.com> <1293085424-18212-6-git-send-email-youquan.song@intel.com> <1293085424-18212-7-git-send-email-youquan.song@intel.com> <20101223105730.GB18363@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223105730.GB18363@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 11:57:30AM +0100, Dominik Brodowski wrote:

> NACK. First of all, why is it only a "turbo mode" if it's 1000 kHz
> difference?

I believe that that's how it's supposed to be defined for Intel systems, 
but you're right that this doesn't belong in generic code. AMD have 
support for enabling/disabling their equivalent functionality through 
sysfs - I'd say that copying that interface and using it to limit the 
set of p-states provided to the core makes more sense.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
