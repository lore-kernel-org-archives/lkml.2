Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0ENGDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:03:32 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36033 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab0ENGDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:03:30 -0400
Date: Fri, 14 May 2010 15:02:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linuxppc-dev@ozlabs.org,
       David H?rdeman <david@hardeman.nu>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-mips@linux-mips.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] media/IR: Add missing include file to rc-map.c
Message-ID: <20100514060240.GD12002@linux-sh.org>
References: <201005051720.22617.PeterHuewe@gmx.de> <201005112042.14889.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005112042.14889.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 08:42:14PM +0200, Peter H?we wrote:
> Am Mittwoch 05 Mai 2010 17:20:21 schrieb Peter H?we:
> > From: Peter Huewe <peterhuewe@gmx.de>
> > 
> > This patch adds a missing include linux/delay.h to prevent
> > build failures[1-5]
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> Any updates on this patch?
> Issue still exists with today's linux-next tree
> 
You might want to send this to the linux-next list at least. If the
people who introduced the breakage are unresponsive (as often tends to be
the case with -next) it's still worth getting trivial fixes rolled in for
the interim. This change doesn't exist outside of -next and whatever tree
introduced it, so there's not much else anyone can do about it at
present.
