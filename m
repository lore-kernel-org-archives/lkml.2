Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0KIHKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 02:10:33 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44630 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0KIHKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 02:10:32 -0500
Date: Tue, 9 Nov 2010 08:10:29 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: kernel-janitors@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/14] arch/mips/pmc-sierra/yosemite/setup.c: delete double
 assignment
In-Reply-To: <20101109004808.GA10116@linux-mips.org>
Message-ID: <Pine.LNX.4.64.1011090809480.25928@ask.diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
 <1288088743-3725-7-git-send-email-julia@diku.dk> <20101109004808.GA10116@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Ralf Baechle wrote:

> On Tue, Oct 26, 2010 at 12:25:35PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Delete successive assignments to the same location.
> 
> [...]
> 
> > This change also makes the variable cpu_clock_freq be not used in the
> > current file.  If this is the correct change to plat_time_init, then
> > perhaps the declaration of that variable should be moved elsewhere, or the
> > variable should be deleted completely.
> 
> The 2nd assignment is a temporary override for debugging purpose that is
> it's there intionsionally.

OK, thanks.  I indeed suspected that, but I thought it might be worthwhile 
to mention it, in case it had outlived its usefulness.

julia
