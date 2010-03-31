Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0CaPIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:08:17 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36521 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab0CaPIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:08:15 -0400
Date: Wed, 31 Mar 2010 17:08:54 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, davej@redhat.com, trenn@suse.de,
       linux@dominikbrodowski.net, mingo@elte.hu, tglx@linutronix.de,
       cpufreq@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [-v2 PATCH 2/6] powernow-k8: Add core performance boost support
Message-ID: <20100331150854.GC30028@aftab>
References: <1269610800-23847-1-git-send-email-bp@amd64.org>
 <1269610800-23847-3-git-send-email-bp@amd64.org>
 <20100330154229.dc8ebd24.akpm@linux-foundation.org>
 <20100331061343.GA28659@aftab>
 <20100330232221.826fe933.akpm@linux-foundation.org>
 <20100331063546.GB28659@aftab>
 <20100330233851.17370621.akpm@linux-foundation.org>
 <4BB2EEE1.4010904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB2EEE1.4010904@zytor.com>
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

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, Mar 30, 2010 at 11:42:41PM -0700

> On 03/30/2010 08:38 PM, Andrew Morton wrote:
> > 
> > I've unilaterally decided that all six patches should be merged via the
> > x86 tree, btw.  They could be split between x86 and cpufreq, but I
> > suspect there are interdependencies which would make that hard.
> > 
> 
> I would agree with that.  I'll try to get them in tomorrow.

Cool. I'll have updated versions of the patches soon - just don't take
those yet.

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
