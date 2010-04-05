Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0DEVsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:48:05 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36408 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0DEVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:48:00 -0400
Date: Tue, 6 Apr 2010 06:46:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-s390@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/4] panic: Allow warnings to set different taint flags
Message-ID: <20100405214626.GA25192@linux-sh.org>
References: <1270319696.12516.321.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270319696.12516.321.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 03, 2010 at 07:34:56PM +0100, Ben Hutchings wrote:
> WARN() is used in some places to report firmware or hardware bugs that
> are then worked-around.  These bugs do not affect the stability of the
> kernel and should not set the flag for TAINT_WARN.  To allow for this,
> add WARN_TAINT() and WARN_TAINT_ONCE() macros that take a taint number
> as argument.
> 
> Architectures that implement warnings using trap instructions instead
> of calls to warn_slowpath_*() now implement __WARN_TAINT(taint)
> instead of __WARN().
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> Changes since the previous version:
> - Added note to Documentation/oops-tracing.txt
> - Changed the commit message to distinguish taint numbers from taint
>   flags
> - Removed 'must' from last sentence of commit message; this patch
>   converts all mainline architectures
> 
This seems to be missing my Tested-by from the last iteration, since
there are no functional changes with this version feel free to add it in
again.
