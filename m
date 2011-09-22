Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1IVTpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:45:40 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:52336 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727Ab1IVTpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:45:38 -0400
From: Kevin Hilman <khilman@ti.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        peterz@infradead.org, santosh.shilimkar@ti.com, arjan@linux.intel.com,
        lenb@kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH V6 0/4] cpuidle: Global registration of idle states with per-cpu statistics
Organization: Texas Instruments, Inc.
References: <20110922082840.10520.85895.stgit@localhost6.localdomain6>
Date: Thu, 22 Sep 2011 12:45:32 -0700
In-Reply-To: <20110922082840.10520.85895.stgit@localhost6.localdomain6>
	(Deepthi Dharwar's message of "Thu, 22 Sep 2011 13:58:52 +0530")
Message-ID: <87ty84tl7n.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deepthi Dharwar <deepthi@linux.vnet.ibm.com> writes:

> The following patch series implements global registration of cpuidle
> states, and also has the necessary data structure changes to
> accommodate the per-cpu writable members of the cpuidle_states
> structure.

I reviewed earlier versions of the series, and this version still looks
good to me.  Any reason it is still RFC?

Reviewed-by: Kevin Hilman <khilman@ti.com>

and for the OMAP-specific parts,

Acked-by: Kevin Hilman <khilman@ti.com>

Kevin
