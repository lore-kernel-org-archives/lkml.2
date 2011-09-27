Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1I0RNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:13:07 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:34654 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab1I0RNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:13:05 -0400
From: Kevin Hilman <khilman@ti.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        peterz@infradead.org, santosh.shilimkar@ti.com, arjan@linux.intel.com,
        lenb@kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V7 0/4] cpuidle: Global registration of idle states with per-cpu statistics
Organization: Texas Instruments, Inc.
References: <20110927100202.16043.58669.stgit@localhost6.localdomain6>
Date: Tue, 27 Sep 2011 10:12:58 -0700
In-Reply-To: <20110927100202.16043.58669.stgit@localhost6.localdomain6>
	(Deepthi Dharwar's message of "Tue, 27 Sep 2011 15:32:38 +0530")
Message-ID: <8739fh29k5.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deepthi Dharwar <deepthi@linux.vnet.ibm.com> writes:

> Version 6 of this patch series dated 22nd Sept 2011 was 
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> Acked-by: Kevin Hilman <khilman@ti.com> for OMAP specific parts.
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> Signed-off-by: Jean Pihet <j-pihet@ti.com>

minor: I think this should be a Tested-by from Jean.  Since he was not on
the delivery path, it should not be a sign-off.

Kevin
