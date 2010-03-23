Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0CWOTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:19:13 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37574 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab0CWOTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:19:11 -0400
Date: Tue, 23 Mar 2010 15:19:34 +0100
From: Borislav Petkov <bp@amd64.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Thomas Renninger <trenn@suse.de>, akpm@linux-foundation.org,
       davej@redhat.com, cpufreq@vger.kernel.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] powernow-k8: Add core performance boost support
Message-ID: <20100323141934.GF16493@aftab>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
 <1269283121-11894-3-git-send-email-bp@amd64.org>
 <201003231217.16451.trenn@suse.de>
 <20100323115858.GC16493@aftab>
 <20100323132737.GA8894@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323132737.GA8894@isilmar.linta.de>
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
Date: Tue, Mar 23, 2010 at 02:27:37PM +0100

Hi Dominik,

> On Tue, Mar 23, 2010 at 12:58:58PM +0100, Borislav Petkov wrote:
> > > It could already be set in arch/x86/kernel/cpu/amd.c and
> > > powernow-k8 could use cpu_has(cpu, X86_FEATURE_CPB);
> > 
> > I'd still like to cache the cpb_capable value locally instead of getting
> > x86_cpuinfo percpu var and querying it. Especially if this happens often
> > and not only at driver init.
> 
> If it's a percpu var, isn't it local anyway?

I meant driver-local. So that I don't have to deref even the per_cpu var
and thus save some cycles.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
