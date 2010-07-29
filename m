Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab0G2Tl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:41:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab0G2Tl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:41:58 -0400
Date: Thu, 29 Jul 2010 12:41:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ai Li <aili@codeaurora.org>
Cc: dwalker@codeaurora.org, arjan@linux.intel.com, mingo@elte.hu,
        shemminger@vyatta.com, czoccolo@gmail.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH v2] cpuidle: extend cpuidle and menu governor to handle
 dynamic states
Message-Id: <20100729124141.ee20b34b.akpm@linux-foundation.org>
In-Reply-To: <1280430929.22142.51.camel@ali-lnx.qualcomm.com>
References: <1280352443-28044-1-git-send-email-aili@codeaurora.org>
	<20100728145545.35caf67a.akpm@linux-foundation.org>
	<1280426600.22142.27.camel@ali-lnx.qualcomm.com>
	<20100729114306.093cc58c.akpm@linux-foundation.org>
	<1280430929.22142.51.camel@ali-lnx.qualcomm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 13:15:29 -0600
Ai Li <aili@codeaurora.org> wrote:

> On Thu, 2010-07-29 at 11:43 -0700, Andrew Morton wrote:
> 
> > I'd be reluctant to merge this code without also having code which uses
> > it.  As it is the change is useless and untestable.
> 
> We have local code in the arch/arm/mach-msm branch that uses the new
> cpuidle code.  We are still developing and testing the MSM patches, and
> hope to upstream them in a few weeks.
> 

grumble.

Well, please at least explain all this in the changelogs when you send
out the next version.
