Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab1GLHFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:05:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47814 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1GLHFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:05:35 -0400
Date: Tue, 12 Jul 2011 11:05:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: x86@kernel.org, suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE MSR
Message-ID: <20110712070531.GD27217@sun>
References: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 05:59:07AM +0000, Naga Chumbalkar wrote:
> If there's no special reason to zero-out the "high" 32-bits of the IA32_APIC_BASE
> MSR, let's preserve it.
> 
> The x2APIC Specification doesn't explicitly state any such requirement. (Sec 2.2 
> in: http://www.intel.com/Assets/PDF/manual/318148.pdf).
> 
> Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> 

Looks like a good idea for me. I've reviewed some additional specs
and even some updates, nothing interesting found.

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
