Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1JOWMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 18:12:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37544 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1JOWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 18:12:32 -0400
Date: Sun, 16 Oct 2011 00:12:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tejun Heo <tj@kernel.org>
Cc: "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>
Subject: Re: WARNING: at arch/x86/kernel/apic/apic.c:1239 setup_local_APIC+...
Message-ID: <20111015221215.GA25519@aftab>
References: <20111014135516.GC11990@aftab>
 <20111014165604.GA14286@aftab>
 <20111014175556.GE4294@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014175556.GE4294@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 01:55:56PM -0400, Tejun Heo wrote:
> Jan hit similar problem a while back.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1180954
> 
> I can't seem to find the patch in mainline.  Jan, Ingo?  Borislav,
> would the patch there resolve the warning you're seeing too?

There's even a -v2 at http://marc.info/?l=linux-kernel&m=131722471001895

We'll run that one to test.

> Anyways, to summarize, the early apic thing isn't necessary anymore
> and can be ripped out and the warning is pretty much bogus at this
> point.  I'll rip it out soonish.

Ok, thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
