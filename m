Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1LBBfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:35:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57595 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab1LBBft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:35:49 -0500
Date: Fri, 2 Dec 2011 09:35:38 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] clocksource: Also tweak ->maxadj in
 clocksource_calc_mult_shift()
Message-ID: <20111202013538.GA15687@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
 <1322724016-9770-2-git-send-email-yong.zhang0@gmail.com>
 <1322783907.21423.153.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1322783907.21423.153.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 03:58:27PM -0800, john stultz wrote:
> On Thu, 2011-12-01 at 15:20 +0800, Yong Zhang wrote:
> > There is still user of clocksource_calc_mult_shift(), and it's
> > complement to commit d65670a7 [clocksource: Avoid selecting mult
> > values that might overflow when adjusted]
> 
> I'd probably drop this patch, as its just extra churn.

Hmm, so you drop option#1,

> 
> Again, I've queued 2/3 to resolve the issue and queued a simplified 3/3
> to just remove clocksource_calc_mult_shift. 

and take option#2 instead (and 3/3 will become more simple).
Both work to me ;-)

Thank you John.

-Yong
