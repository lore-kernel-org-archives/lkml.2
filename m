Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553Ab0HMMeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 08:34:23 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42414 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab0HMMeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:34:22 -0400
Date: Fri, 13 Aug 2010 14:35:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD
 machines
Message-ID: <20100813123543.GC9046@aftab>
References: <1280940316-7966-1-git-send-email-bp@amd64.org>
 <1280940316-7966-2-git-send-email-bp@amd64.org>
 <4C59F24B.1010702@zytor.com>
 <20100805074503.GI18307@amd.com>
 <4C5AC736.20903@zytor.com>
 <20100812144142.GY23755@8bytes.org>
 <4C64148D.5080305@zytor.com>
 <20100812170644.GZ23755@8bytes.org>
 <4C644507.9020606@zytor.com>
 <20100812190414.GA23755@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812190414.GA23755@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joro@8bytes.org>
Date: Thu, Aug 12, 2010 at 03:04:14PM -0400

> On Thu, Aug 12, 2010 at 12:01:27PM -0700, H. Peter Anvin wrote:
> > On 08/12/2010 10:06 AM, Joerg Roedel wrote:
> 
> > > The synchronization problem might be real. The cpu_init function uses
> > > per-cpu variables which might not be present in the early synced
> > > tramponline page table (iirc). The change to swapper_pg_dir and the
> > > global tlb flush should probably be moved to the very beginning of the
> > > start_secondary function.
> > > 
> > 
> > Are you going to submit an updated patch, then?
> 
> Yes, I will send it next week when I am back in office and gave it some
> testing.

currently testing...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
