Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab0E1PJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:09:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49590 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab0E1PJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:09:51 -0400
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for
 select intel processors
From: Chase Douglas <chase.douglas@canonical.com>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
In-Reply-To: <alpine.LFD.2.00.1005272359510.24823@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
	 <1275013933.2312.7.camel@cndougla-ubuntu>
	 <alpine.LFD.2.00.1005272359510.24823@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 11:09:40 -0400
Message-ID: <1275059380.5612.60.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 00:16 -0400, Len Brown wrote:
> > I see that you have updated this code in your tree to disable C4 and C6
> > on atom. This has piqued my curiosity. I've now seen 2 atom netbooks
> > from different OEMs that hide C4 when you plug the power in. After the
> > first machine I thought, "must be a BIOS/ACPI bug," but now I'm
> > beginning to wonder if there's some issue with atom C4 states? That's
> > beside the fact that I've not seen C6 on either machine at all. Do you
> > have any insight?
> 
> The reasoning behind ACPI taking deep C-states away
> when on AC is the assumption that users on AC
> care more about low latency and high performance
> than they care about power savings, heat, and noise.

Maybe they forgot that a netbook is still a *lap*top when they did this,
cause I can't keep mine on my lap when it's plugged in :). The CPU idles
at 60 centigrade when powered on, and drops to a manageable 30-ish
centigrade when running on battery.

> So my intent is to give Linux control over this decision,
> via PM_QOS or otherwise.  At the moment C4 is commented out
> because when i first tested it failed the lapic timer workaround.

I am looking forward to testing out these changes on my netbook once
this issue get sorted out!

-- Chase

