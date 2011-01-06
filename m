Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1AFPxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:53:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:56601 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab1AFPxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:53:50 -0500
Date: Thu, 6 Jan 2011 10:53:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Andi Kleen <andi@firstfloor.org>, Greg KH <gregkh@suse.de>
Subject: Re: [34-longterm 000/260] v2.6.34.8 longterm review
Message-ID: <20110106155335.GC30150@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
 <4D21A7E8.3090709@gmail.com>
 <20110104191158.GO30150@windriver.com>
 <4D25B9D6.80503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D25B9D6.80503@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Jan 2011 15:53:36.0301 (UTC) FILETIME=[E0D82DD0:01CBADB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [34-longterm 000/260] v2.6.34.8 longterm review] On 06/01/2011 (Thu 13:47) Jiri Slaby wrote:

> CCing:
> gregkh (32-stable)
> ak (35-stable)
> 
> On 01/04/2011 08:11 PM, Paul Gortmaker wrote:
> > If you want to look around at what else is in "next_round" you can grab
> > the queue from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.34.git
> > 
> > Let me know if you still think something is missing, and/or call out the
> > upstream commit IDs explicitly and I'll do the right thing.
> 
> Hi,
> e2efafbf139d2bfdfe96f2901f03189fecd172e4
> is still missing (I've just checked SLE11SP1 and openSUSE 11.3, which is
> based on .32 and .34 respectively and the problem is easily reproducible
> there). It is trivial to be backported.

Thanks, it does look like a candidate for adding to next_round.

P.

> 
> thanks,
> -- 
> js
