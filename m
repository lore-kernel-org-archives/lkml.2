Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab1LFPbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:31:15 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51092 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab1LFPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:31:13 -0500
Date: Tue, 6 Dec 2011 16:31:08 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Message-ID: <20111206153108.GD28735@gere.osrc.amd.com>
References: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
 <20111205131825.GA31275@gere.osrc.amd.com>
 <0207C53569FE594381A4F2EB66570B2A018EE61884@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A018EE61884@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 02:18:26PM -0800, Luck, Tony wrote:
> This looks like a sane improvement, Tony I'm assuming you're handling this?
> 
> I can push this - but it would be nice to have some other comments from
> outside of Intel (we've been beaten up written-by Intel, acked-by: Intel
> too many times).
> 
> Can I count that as an "Acked-by:"?

Well, from looking at Udo's feedback here

http://marc.info/?l=linux-kernel&m=132206108724885

this patch looks like it helps in his case partially. I'm still not sure
about all the printks in therm_throt_process(), do you guys feel the
need to notify the user that the CPU clock was throttled/power limits
were applied, or rather have something more subtle...?

Hmmm.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
