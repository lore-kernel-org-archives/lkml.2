Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0CWMFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:05:13 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44295 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0CWMFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:05:11 -0400
Date: Tue, 23 Mar 2010 13:05:34 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Renninger <trenn@suse.de>
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cpufreq: Unify sysfs attribute definition macros
Message-ID: <20100323120534.GE16493@aftab>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
 <201003231207.29230.trenn@suse.de>
 <20100323114408.GB16493@aftab>
 <201003231255.30461.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003231255.30461.trenn@suse.de>
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

From: Thomas Renninger <trenn@suse.de>
Date: Tue, Mar 23, 2010 at 12:55:30PM +0100

> > Well, struct freq_attr for example is cpufreq-specific attribute,
> > AFAICT. So, keeping them in cpufreq.h should be fine, no?
> You don't need much of these (one or two?).

I don't think I get what you mean here..?

> I'd leave this cleanup out for your patch series.
> You care about the boost and aperf/mperf stuff and not about this
> cleanup?

Why? What's wrong with cleaning up obviously duplicated code?

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
