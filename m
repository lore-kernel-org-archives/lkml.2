Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab2CMB1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:27:40 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:54399 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2CMB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:27:38 -0400
Date: Tue, 13 Mar 2012 10:27:34 +0900
From: Simon Horman <horms@verge.net.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
Subject: Re: [PATCH 0/6] PM / Domains: System suspend fixes and "always on"
 flag
Message-ID: <20120313012731.GA9482@verge.net.au>
References: <201203130123.16268.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203130123.16268.rjw@sisk.pl>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 01:23:15AM +0100, Rafael J. Wysocki wrote:
> Hi all,
> 
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

Hi Rafael,

I have tested that my Mackerel boots with the default config and each of
these patches applied in turn. The tests were made on head of the
linux-next branch of your linux-pm tree ("sh_mmcif / PM: Use PM QoS latency
constraint") + the "sh-sci / PM: Avoid deadlocking runtime PM" patch at the
link below.

http://marc.info/?l=linux-sh&m=133073065924863&w=4

Please let me know if there are other tests you would like run.

All patches:

Tested-by: Simon Horman <horms@verge.net.au>
