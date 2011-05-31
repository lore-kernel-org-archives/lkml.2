Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab1EaOYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:24:17 -0400
Received: from vt.electrainfo.com ([207.136.236.70]:60534 "EHLO
	black.electrainfo.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754782Ab1EaOYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:24:16 -0400
Date: Tue, 31 May 2011 10:24:15 -0400
From: Whit Blauvelt <whit@transpect.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: recursive fault in 2.6.35.5
Message-ID: <20110531142415.GA17781@black.transpect.com>
References: <20110529162738.GA7832@black.transpect.com>
 <1306723709.4895.4.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306723709.4895.4.camel@marge.simson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 04:48:29AM +0200, Mike Galbraith wrote:

> No, you've been bitten by an annoyingly elusive load balancing bug.

Thanks Mike. Can that bug be avoided by leaving out some kernel option? The
system that happened on had it's identical twin fail the day before. For
both, it was a time of relatively more load (although not excessive). On the
twin we didn't look at the console before rebooting though.

On the other hand, we'd run for months with no problem up until this.

Regards,
Whit

