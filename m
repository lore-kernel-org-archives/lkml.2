Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab0KJOAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:00:19 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34152 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0KJOAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:00:14 -0500
Date: Wed, 10 Nov 2010 14:59:17 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jesper Juhl <jj@chaosbits.net>,
        "amd64-microcode@amd64.org" <amd64-microcode@amd64.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] microcode, AMD: Cleanup code a bit
Message-ID: <20101110135917.GD9518@aftab>
References: <20101102175248.GA25781@aftab>
 <20101110083121.GD3341@elte.hu>
 <20101110113300.GA9518@aftab>
 <20101110132246.GA11388@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110132246.GA11388@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 08:22:46AM -0500, Ingo Molnar wrote:
> > git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tip-microcode
> 
> Ok, good. Please fix commit 35dc0ff46f77 if you want me to pull it, you should be in 
> the signoff chain as a submaintainer who pushes bits, i.e. your entry should be:
> 
>   Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> not:
> 
>   Acked-by: Borislav Petkov <borislav.petkov@amd.com>

done,

> Also, while touching up details, please remove the colon after the sentence:
> 
>   35dc0ff46f77: microcode, AMD: Prefer vzalloc() over calls to vmalloc()+memset().

done (simplified commit message, while at it),

> All arch/x86 commit titles are open-ended sentences that start with a verb.
> 
> Also, please use a 'x86, microcode, AMD: ' prefix.

and done. Branch updated.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
