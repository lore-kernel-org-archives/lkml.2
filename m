Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1A0XnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:43:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39717 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1A0XnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:43:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 08:37:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memsw: Deprecate noswapaccount kernel parameter and
 schedule it for removal
Message-Id: <20110128083703.a154050b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110127104759.GA4301@tiehlicka.suse.cz>
References: <20110126152158.GA4144@tiehlicka.suse.cz>
	<20110126140618.8e09cd23.akpm@linux-foundation.org>
	<20110127082320.GA15500@tiehlicka.suse.cz>
	<20110127180330.78585085.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127092951.GA8036@tiehlicka.suse.cz>
	<20110127184827.a8927595.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127104759.GA4301@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 11:47:59 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 27-01-11 18:48:27, KAMEZAWA Hiroyuki wrote:
> > Could you try to write a patch for feature-removal-schedule.txt
> > and tries to remove noswapaccount and do clean up all ?
> > (And add warning to noswapaccount will be removed.....in 2.6.40)
> 
> Sure, no problem. What do you think about the following patch?
> ---
> From a597421909a3291886345565c73102117a52301e Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Thu, 27 Jan 2011 11:41:01 +0100
> Subject: [PATCH] memsw: Deprecate noswapaccount kernel parameter and schedule it for removal
> 
> noswapaccount couldn't be used to control memsw for both on/off cases so
> we have added swapaccount[=0|1] parameter. This way we can turn the
> feature in two ways noswapaccount resp. swapaccount=0. We have kept the
> original noswapaccount but I think we should remove it after some time
> as it just makes more command line parameters without any advantages and
> also the code to handle parameters is uglier if we want both parameters.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Requested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Nice!. Thank you.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Maybe other discussion as 2.6.40 is too early or some may happen.
But Ack from me, at least.

