Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668Ab0COSvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:51:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965642Ab0COSvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:51:20 -0400
Date: Mon, 15 Mar 2010 11:47:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>,
       kernel-janitors@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-mips@linux-mips.org,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH] init dynamic bin_attribute structures
In-Reply-To: <alpine.LRH.2.00.1003151055060.26353@twin.jikos.cz>
Message-ID: <alpine.LFD.2.00.1003151144550.18017@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org> <1268612981-9009-1-git-send-email-w.sang@pengutronix.de> <alpine.LRH.2.00.1003151055060.26353@twin.jikos.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Mar 2010, Jiri Kosina wrote:
> 
> I don't understand how cocinelle works, but the resulting patch seems to 
> be incomplete.
> 
> The fix is needed at least in firmware loader (for which Greg has already 
> queued patch), in ACPI thermal driver [1], etc).

The firmware loader should be done differently:

	http://patchwork.kernel.org/patch/84814/

and I suspect that Wolfram may have skipped the thermal one as having been 
done by another patch (that I didn't merge, due to having questions about 
the whole issue, but that I don't have any objections to)

But maybe there is also some limitation to the coccinelle rule too.

		Linus
