Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1EPRcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:32:02 -0400
Received: from kroah.org ([198.145.64.141]:57157 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab1EPRb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:31:58 -0400
Date: Mon, 16 May 2011 10:31:28 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Frank Arnold <farnold@amd64.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>
Subject: Re: [PATCH 1/3] x86, AMD, cacheinfo: Fix fallout caused by max3
 conversion
Message-ID: <20110516173128.GC13011@kroah.com>
References: <1305553188-21061-1-git-send-email-bp@amd64.org>
 <1305553188-21061-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305553188-21061-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 03:39:46PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> 732eacc0542d0aa48797f675888b85d6065af837 converted code around the
> kernel using nested max() macros to use the new max3 macro but forgot to
> remove the old line in intel_cacheinfo.c. Fix it.
> 
> Cc: Hagen Paul Pfeifer <hagen@jauu.net>
> Cc: Frank Arnold <farnold@amd64.org>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Please also add:

Cc: Stable <stable@kernel.org>

here to resolve the regression found in the last .38 release.

thanks,

greg k-h
