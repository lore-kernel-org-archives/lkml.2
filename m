Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab2GSNjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:39:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60275 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab2GSNjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:39:48 -0400
Date: Thu, 19 Jul 2012 15:39:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: msb@chromium.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        shaohua.li@intel.com, yinghai@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, tj@kernel.org,
        akpm@linux-foundation.org, sfr@canb.auug.org.au, cl@gentwo.org,
        olofj@chromium.org, paulmck@linux.vnet.ibm.com,
        Alex Shi <alex.shi@intel.com>, Conny Seidel <conny.seidel@amd.com>
Subject: Re: [PATCH] x86, mm: Send tlb flush IPIs to online cpus only
Message-ID: <20120719133948.GA10050@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	msb@chromium.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
	shaohua.li@intel.com, yinghai@kernel.org, tglx@linutronix.de,
	hpa@zytor.com, x86@kernel.org, tj@kernel.org,
	akpm@linux-foundation.org, sfr@canb.auug.org.au, cl@gentwo.org,
	olofj@chromium.org, paulmck@linux.vnet.ibm.com,
	Alex Shi <alex.shi@intel.com>, Conny Seidel <conny.seidel@amd.com>
References: <20120719125643.30033.58913.stgit@srivatsabhat.in.ibm.com>
 <20120719133229.GB10073@x1.osrc.amd.com>
 <50080D37.3000808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50080D37.3000808@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 07:05:51PM +0530, Srivatsa S. Bhat wrote:
> Oh.. ok.. Then this patch is perhaps unnecessary.. Thanks for the
> info!

Probably, if the TLB flushrange set from Alex goes upstream in the next
merge window...

-- 
Regards/Gruss,
Boris.
