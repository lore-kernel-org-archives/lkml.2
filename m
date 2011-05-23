Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1EWFq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:46:28 -0400
Received: from linux-sh.org ([111.68.239.195]:57063 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab1EWFqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:46:25 -0400
Date: Mon, 23 May 2011 14:45:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, ying.huang@intel.com, ssp@redhat.com,
        namhyung@gmail.com, fweisbec@gmail.com, x86@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, robert.richter@amd.com
Subject: Re: [PATCH 1/2] sh: remove warning and warning_symbol from struct stacktrace_ops
Message-ID: <20110523054522.GH5206@linux-sh.org>
References: <1305205872-10321-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305205872-10321-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 03:11:11PM +0200, Richard Weinberger wrote:
> Both warning and warning_symbol are nowhere used.
> Let's get rid of them.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

The SH code obviously simply copied the x86 design, but it seems
reasonable to kill these off given that there are no users of the
interface. Applied, thanks.
