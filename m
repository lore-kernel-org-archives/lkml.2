Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab0DHRXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:23:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847Ab0DHRXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:23:23 -0400
Date: Thu, 8 Apr 2010 10:19:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, Shanyu Zhao <shanyu.zhao@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6. v2.6.34-rc3-406
 oops with 4965AGN wireless
In-Reply-To: <Pine.LNX.4.64.1004090104570.7829@boston.corp.fedex.com>
Message-ID: <alpine.LFD.2.00.1004081017360.3558@i5.linux-foundation.org>
References: <Pine.LNX.4.64.1004090104570.7829@boston.corp.fedex.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Apr 2010, Jeff Chua wrote:
> 
> I'm having problem with the latest git pull 2 days ago with the 4965AGN
> wireless.
> 
> Starting the wireless with WPA2 resulted in system hard freeze. Reverting the
> commit below solves the problem.

I don't mind reverting patches, but I hate doing it blind and without 
_any_ chance for the guilty party to try to fix it first.

Can you post the oops that your subject implies happened? Maybe the driver 
authors can find the proper fix without a revert?

I'll revert if if I hear no updates in a couple of days - please remind 
me.

			Linus
