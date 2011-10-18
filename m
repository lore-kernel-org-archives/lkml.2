Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab1JRPtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:49:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47615 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab1JRPte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:49:34 -0400
Date: Tue, 18 Oct 2011 17:49:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, microcode: Correct microcode revision format
Message-ID: <20111018154914.GE17076@aftab>
References: <1318865115-9904-1-git-send-email-bp@amd64.org>
 <1318865115-9904-2-git-send-email-bp@amd64.org>
 <20111018151316.GA1345@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018151316.GA1345@alboin.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 11:13:16AM -0400, Andi Kleen wrote:
> On Mon, Oct 17, 2011 at 05:25:14PM +0200, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > 506ed6b53e00ba303ad778122f08e1fca7cf5efb added microcode revision format
> > to /proc/cpuinfo and the MCE handler in decimal format but both AMD and
> > Intel patch levels are handled as hex numbers. Fix it.
> 
> Acked-by: Andi Kleen <ak@linux.intel.com>
> 
> BTW if you want microcode output on AMD you'll need to implement
> code to fill the field in on those CPUs.

Yeah, a second patch does that already.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
