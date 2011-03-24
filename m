Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab1CXGho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:37:44 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:48676 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab1CXGhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:37:42 -0400
Date: Thu, 24 Mar 2011 12:08:15 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 15/15] sched: add documentation for bandwidth control
Message-ID: <20110324063815.GC2721@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110323030326.789836913@google.com>
 <20110323030450.137361644@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323030450.137361644@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:03:41PM -0700, Paul Turner wrote:
> +
> +System wide settings
> +--------------------
> +The amount of runtime obtained from global pool every time a CPU wants the
> +group quota locally is controlled by a sysctl parameter
> +sched_cfs_bandwidth_slice_us. The current default is 10ms. This can be changed

Needs to change the default value to 5ms now.

Regards,
Bharata.
