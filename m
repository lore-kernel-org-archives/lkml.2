Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1AVKLo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 05:11:44 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33857 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1AVKLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 05:11:42 -0500
Date: Sat, 22 Jan 2011 11:14:03 +0100
From: Borislav Petkov <bp@amd64.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Richter, Robert" <robert.richter@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        Alok N Kataria <akataria@vmware.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Hans J. Koch" <hjk@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Move llc_shared_map out of cpu_info
Message-ID: <20110122101403.GB23987@aftab>
References: <4D3A16E8.5020608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3A16E8.5020608@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 06:29:44PM -0500, Yinghai Lu wrote:
> 
> cpu_info is already with per_cpu, We can take llc_shared_map out of cpu_info,
> and declare it as per_cpu variable directly.
> 
> So later referencing could be simple and directly instead of diving to find
> cpu_info at first.
> 
> Also could make smp_store_cpu_info() much simple to avoid to do save and restore trick.
> 
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Yep, it's only natural to do that.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
