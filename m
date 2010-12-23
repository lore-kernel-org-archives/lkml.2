Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0LWOmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:42:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42453 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab0LWOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:42:34 -0500
Date: Thu, 23 Dec 2010 14:42:20 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Youquan Song <youquan.song@intel.com>
Cc: davej@redhat.com, cpufreq@vger.kernel.org, venki@google.com,
        arjan@linux.intel.com, lenb@kernel.org, suresh.b.siddha@intel.com,
        kent.liu@intel.com, chaohong.guo@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 0/6] cpufreq: Add sampling window to enhance ondemand
	governor power efficiency
Message-ID: <20101223144220.GB1402@srcf.ucam.org>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've generally been assuming (rightly or wrongly) that getting into 
deep C states is preferable to being active (even at a lower frequency), 
and so the current behaviour of tending to rapidly switch to the maximum 
P state isn't inherently a problem. What kind of power savings are you 
benchmarking with this, and do you still see a saving if you just 
disable turbo mode?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
