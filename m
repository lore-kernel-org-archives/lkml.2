Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1DVXGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:06:49 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:43116 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755269Ab1DVXGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:06:47 -0400
From: Kevin Hilman <khilman@ti.com>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [linux-pm] [RFC PATCH V3 4/4] cpuidle: Single/Global registration of idle states
Organization: Texas Instruments, Inc.
References: <20110420065445.332.13688.stgit@tringupt.in.ibm.com>
	<20110420065608.332.30043.stgit@tringupt.in.ibm.com>
	<87k4eo6d5m.fsf@ti.com> <4DAFB847.50404@linux.vnet.ibm.com>
Date: Fri, 22 Apr 2011 16:06:42 -0700
In-Reply-To: <4DAFB847.50404@linux.vnet.ibm.com> (Trinabh Gupta's message of
	"Thu, 21 Apr 2011 10:23:27 +0530")
Message-ID: <871v0tvqbh.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trinabh,

Trinabh Gupta <trinabh@linux.vnet.ibm.com> writes:

[...]

> I just wanted to get comments on the design and understand how it
> affects various architectures in question. It looks to me as if the
> design should be okay and infact better for architectures like ARM
> since they do not have different idle states for different cpus and
> thus do not require per-cpu registration.  Global registration would
> work and be simpler; please correct me if I am wrong.

Yes, I agree that the new design is better, I especially like that it's
more clear (and expected) that final state decision making is to be done
directly in the driver without the back-and-forth in the current setup.

Thanks,

Kevin
