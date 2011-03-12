Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1CLTtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 14:49:18 -0500
Received: from www.tglx.de ([62.245.132.106]:34343 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab1CLTtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 14:49:17 -0500
Date: Sat, 12 Mar 2011 20:49:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: akpm@linux-foundation.org
cc: mm-commits@vger.kernel.org, joe@perches.com,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + maintainers-remove-unused-clockeventsh.patch added to -mm
 tree
In-Reply-To: <201102242233.p1OMXulK030735@imap1.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1103122043030.2787@localhost6.localdomain6>
References: <201102242233.p1OMXulK030735@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, akpm@linux-foundation.org wrote:
> -F:	include/linux/clockevents.h

Sigh, can we stop merging stuff which is obviously based on shell
scripts w/o any brain interaction ?

Yes, I fat fingered that, but is it really rocket science to figure
out that it should have been include/linux/clockchips.h ?

Thanks,

	tglx

