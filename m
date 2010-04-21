Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0DUTZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:25:19 -0400
Received: from kelvin.asmallorange.com ([207.210.111.10]:35746 "EHLO
	kelvin.asmallorange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab0DUTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:25:16 -0400
Date: Thu, 22 Apr 2010 00:56:00 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 00/10] ARM: ftrace: cleanups, Thumb-2, and dynamic
 ftrace (v2)
Message-ID: <20100421192600.GA17985@debian>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268462987-8271-1-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - kelvin.asmallorange.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rab.in
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Sat, Mar 13, 2010 at 12:19:37PM +0530, Rabin Vincent wrote:
> This series contains fixes and improvements to the ARM ftrace support.  It adds
> Thumb-2 support and re-implements the dynamic ftrace support.

Do you have any further concerns about this patchset?

If not, do you mind if I try to send in the series (v2 + the two updated
patches) via the ARM patch system, since most of the patches only touch
code under arch/arm/?

Rabin
