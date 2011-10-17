Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1JQHYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:24:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44191 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1JQHYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:24:11 -0400
Date: Mon, 17 Oct 2011 09:23:52 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Conny Seidel <conny.seidel@amd.com>, Tejun Heo <tj@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>, x86 <x86@kernel.org>
Subject: Re: WARNING: at arch/x86/kernel/apic/apic.c:1239 setup_local_APIC+...
Message-ID: <20111017072352.GA4940@aftab>
References: <20111014135516.GC11990@aftab>
 <20111014165604.GA14286@aftab>
 <20111014175556.GE4294@google.com>
 <20111015221215.GA25519@aftab>
 <20111017000759.3d1f4310.conny.seidel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017000759.3d1f4310.conny.seidel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 06:07:59PM -0400, Conny Seidel wrote:
> On Sat, 15 Oct 2011 18:12:15 -0400
> Borislav Petkov <bp@amd64.org> wrote:
> 
> >On Fri, Oct 14, 2011 at 01:55:56PM -0400, Tejun Heo wrote:
> >> Jan hit similar problem a while back.
> >>
> >>   http://thread.gmane.org/gmane.linux.kernel/1180954
> >>
> >> I can't seem to find the patch in mainline.  Jan, Ingo?  Borislav,
> >> would the patch there resolve the warning you're seeing too?
> >
> >There's even a -v2 at
> >http://marc.info/?l=linux-kernel&m=131722471001895
> >
> >We'll run that one to test.
> 
> Looks good. The warning is gone.

Good. Ingo, you can have our

Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Tested-by: Conny Seidel <conny.seidel@amd.com>

for it, it being the -v2 at http://marc.info/?l=linux-kernel&m=131722471001895

Thanks to all for their work.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
