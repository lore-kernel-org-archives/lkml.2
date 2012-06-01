Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab2FAO5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:57:08 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49383 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107Ab2FAO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:57:05 -0400
Date: Fri, 1 Jun 2012 16:57:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] x86, CPU, AMD: Cleanup AMD-specific MSR-rw users
Message-ID: <20120601145732.GA28216@aftab.osrc.amd.com>
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
 <4FC8D766.1070700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC8D766.1070700@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 07:53:26AM -0700, H. Peter Anvin wrote:
> Looks good.  This can be for 3.6, right (no immediate urgency)?

None on arch/x86/ - simply correctness fixes.

And I'm assuming since you took Konrad's patch, there are no pending
issues for xen either.

So yeah, this can wait for 3.6, IMHO.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
