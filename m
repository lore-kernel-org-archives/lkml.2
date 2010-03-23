Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0CWQ0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:26:22 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39960 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab0CWQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:26:17 -0400
Date: Tue, 23 Mar 2010 17:26:40 +0100
From: Borislav Petkov <bp@amd64.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Thomas Renninger <trenn@suse.de>, akpm@linux-foundation.org,
       davej@redhat.com, cpufreq@vger.kernel.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] powernow-k8: Add core performance boost support
Message-ID: <20100323162640.GK16493@aftab>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
 <1269283121-11894-3-git-send-email-bp@amd64.org>
 <201003231217.16451.trenn@suse.de>
 <20100323115858.GC16493@aftab>
 <20100323132737.GA8894@isilmar.linta.de>
 <20100323141934.GF16493@aftab>
 <20100323144757.GB17587@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323144757.GB17587@isilmar.linta.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Tue, Mar 23, 2010 at 03:47:57PM +0100

> > > If it's a percpu var, isn't it local anyway?
> > 
> > I meant driver-local. So that I don't have to deref even the per_cpu var
> > and thus save some cycles.
> 
> Well, it doesn't seem to be used in any hot path (and if it were, using a
> per-cpu var was better anyway, because of no contention etc.). If it really
> saves some cycles, I'm more than fine with keeping it; still, informing the
> user in /proc/cpuinfo seems like a sensible thing to do.

No, the idea was to do the local caching _in addition_ to advertising it
over /proc/cpuinfo. Let's see what the x86 maintainers think though...

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
