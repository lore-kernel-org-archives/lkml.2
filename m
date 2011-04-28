Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab1D1Uzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:55:32 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41371 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636Ab1D1Uz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:55:29 -0400
Subject: Re: [PATCH] clocksource: sh_cmt: Runtime PM support
From: john stultz <johnstul@us.ibm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, simon@horms.net,
        linux-sh@vger.kernel.org
In-Reply-To: <20110425133610.4213.81763.sendpatchset@t400s>
References: <20110425133610.4213.81763.sendpatchset@t400s>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 13:55:21 -0700
Message-ID: <1304024121.2971.105.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 22:36 +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add Runtime PM support to the CMT driver.
> 
> The hardware device is enabled as long as the clocksource
> or the clockevent portion of the driver is used.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: John Stultz <johnstul@us.ibm.com>



