Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab2FFVmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:42:38 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45694 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838Ab2FFVlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:41:55 -0400
Date: Wed, 6 Jun 2012 23:42:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/6] x86: mce: Create devices in CPU_UP_PREPARE
Message-ID: <20120606214219.GC6841@aftab.osrc.amd.com>
References: <20120606211746.693649684@linutronix.de>
 <20120606212334.513459224@linutronix.de>
 <alpine.LFD.2.02.1206062337310.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206062337310.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:38:11PM +0200, Thomas Gleixner wrote:
> On Wed, 6 Jun 2012, Thomas Gleixner wrote:
> 
> > This makes the treshold_cpu_callback for AMD actually work and makes
> > the code symetric vs. teardown.
> 
> Ignore that. I sent out the wrong version of this lot. Sorry for the noise

By this you mean the chunk at the end of 5/6, right?

There's a chunk touching amd_64_threshold_cpu_callback...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
