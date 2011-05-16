Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1EPRjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:39:04 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36277 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1EPRjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:39:02 -0400
Date: Mon, 16 May 2011 19:38:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg KH <greg@kroah.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Frank Arnold <farnold@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>
Subject: Re: [PATCH 1/3] x86, AMD, cacheinfo: Fix fallout caused by max3
 conversion
Message-ID: <20110516173816.GE22383@aftab>
References: <1305553188-21061-1-git-send-email-bp@amd64.org>
 <1305553188-21061-2-git-send-email-bp@amd64.org>
 <20110516173128.GC13011@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516173128.GC13011@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 01:31:28PM -0400, Greg KH wrote:
> On Mon, May 16, 2011 at 03:39:46PM +0200, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > 732eacc0542d0aa48797f675888b85d6065af837 converted code around the
> > kernel using nested max() macros to use the new max3 macro but forgot to
> > remove the old line in intel_cacheinfo.c. Fix it.
> > 
> > Cc: Hagen Paul Pfeifer <hagen@jauu.net>
> > Cc: Frank Arnold <farnold@amd64.org>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> Please also add:
> 
> Cc: Stable <stable@kernel.org>
> 
> here to resolve the regression found in the last .38 release.

I think you mean this regression:

http://marc.info/?l=linux-kernel&m=130541471818831

If so, we're working on that too. The patch above is just a small fixlet
which shouldn't go to stable.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
