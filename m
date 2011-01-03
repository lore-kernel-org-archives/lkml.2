Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1ACMym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 07:54:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:43704 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab1ACMyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 07:54:41 -0500
Date: Mon, 3 Jan 2011 13:54:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stefan Weil <weil@mail.berlios.de>,
        Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
        linux-kernel@vger.kernel.org, Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH] Fix spelling milisec -> ms in module parameter
 description
In-Reply-To: <AANLkTimZs7d6NtNST7rN6rrdAqmnFyf9nEJDTZ5Nb4Bm@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1101031354280.26685@pobox.suse.cz>
References: <1293978109-5288-1-git-send-email-weil@mail.berlios.de> <AANLkTimZs7d6NtNST7rN6rrdAqmnFyf9nEJDTZ5Nb4Bm@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Jan 2011, Geert Uytterhoeven wrote:

> On Sun, Jan 2, 2011 at 15:21, Stefan Weil <weil@mail.berlios.de> wrote:
> > Instead of replacing 'milisec' by 'millisec', I decided to use
> > the more common SI unit. Other drivers use 'milliseconds'
> > or 'ms', too ('millisec' is never used).
> >
> > Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
