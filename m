Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2CMBoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:44:22 -0400
Received: from linux-sh.org ([111.68.239.195]:55915 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759346Ab2CMBoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:44:20 -0400
Date: Tue, 13 Mar 2012 10:44:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
Subject: Re: [PATCH 0/6] PM / Domains: System suspend fixes and "always on" flag
Message-ID: <20120313014408.GA9916@linux-sh.org>
References: <201203130123.16268.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203130123.16268.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 01:23:15AM +0100, Rafael J. Wysocki wrote:
> The following patches fix system suspend/resume and hibernation device
> callback routines in the generic PM domains code and add an "always on" flag
> for devices allowing their drivers to protect them from surprise power
> removals.
> 
> [1/6] - Fix system resume of devices involved in system wakeup.
> [2/6] - Fix hibernation restore of devices.
> [3/6] - Introduce "always on" flag for "special" devices in PM domains.
> [4/6] - Make TMU clocksource driver use the "always on" flag.
> [5/6] - Make CMT clocksource driver use the "always on" flag.
> [6/6] - Make MTU2 clocksource driver use the "always on" flag.
> 
> All of them are v3.4 material if there are no objections.
> 
Looks good to me.

Acked-by: Paul Mundt <lethal@linux-sh.org>
