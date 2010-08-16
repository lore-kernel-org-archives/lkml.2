Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0HPMRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:17:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36358 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0HPMRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:17:51 -0400
Date: Mon, 16 Aug 2010 14:19:33 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joerg Roedel <joro@8bytes.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD
 machines
Message-ID: <20100816121933.GA28147@aftab>
References: <1280940316-7966-2-git-send-email-bp@amd64.org>
 <4C59F24B.1010702@zytor.com>
 <20100805074503.GI18307@amd.com>
 <4C5AC736.20903@zytor.com>
 <20100812144142.GY23755@8bytes.org>
 <4C64148D.5080305@zytor.com>
 <20100812170644.GZ23755@8bytes.org>
 <4C644507.9020606@zytor.com>
 <20100812190414.GA23755@8bytes.org>
 <20100813123543.GC9046@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813123543.GC9046@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@amd64.org>
Date: Fri, Aug 13, 2010 at 08:35:43AM -0400

> > > > The synchronization problem might be real. The cpu_init function uses
> > > > per-cpu variables which might not be present in the early synced
> > > > tramponline page table (iirc). The change to swapper_pg_dir and the
> > > > global tlb flush should probably be moved to the very beginning of the
> > > > start_secondary function.
> > > > 
> > > 
> > > Are you going to submit an updated patch, then?
> > 
> > Yes, I will send it next week when I am back in office and gave it some
> > testing.
> 
> currently testing...

Updated versions survived almost 48h of uninterrupted hammering, I'm
sending them as a reply to this message...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
