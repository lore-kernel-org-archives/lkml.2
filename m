Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0E1Hpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:45:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476Ab0E1Hpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:45:49 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] [PATCH 8/8] intel_idle: create a native cpuidle driver for select intel processors
Date: Fri, 28 May 2010 09:46:32 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au
References: <1274928151-30919-1-git-send-email-lenb@kernel.org> <201005271053.31087.trenn@suse.de> <alpine.LFD.2.00.1005272131400.24823@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005272131400.24823@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280946.32981.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 May 2010 03:44:16 Len Brown wrote:
> On Thu, 27 May 2010, Thomas Renninger wrote:
...
> > > This driver does not yet know about cpu online/offline
> > > and thus will not yet play well with cpu-hotplug.
I thought this is also about soft on/offlining.
> 
> > What means does not play well yet, suspend or manually offlining a
> > core will eventually (for sure?) hang the machine?
> 
> It means less power savings savings than optimal
> for processors not present at module load time.
Ok, not really sever...
> 
> > If this is known broken, should this already be spread through
> > linux-next?
> 
> If you know somebody with a system that supports CPU hot-add
> on one of the processors supported by intel_idle, and they
> are willing to test linux-next, please have them contact me.
Real CPU hotplug is broken with acpi processor driver as well,
eventually it got addressed lately. Anyway, not sever...

Thanks,

    Thomas

