Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1BGRhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:37:04 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23946 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab1BGRhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:37:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6250"; a="73299066"
Subject: Re: [PATCH 0/7] Nexus One Support
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
In-Reply-To: <20110204133556.GA2803@ucw.cz>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
	 <20110204133556.GA2803@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 09:36:20 -0800
Message-ID: <1297100180.11955.1.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 14:36 +0100, Pavel Machek wrote:
> On Thu 2011-01-20 12:32:38, Daniel Walker wrote:
> > This series adds basic Nexus One support which includes a booting
> > kernel, and functional MMC .
> > 
> > Most people won't be able to use this yet unfortunately because
> > you need a serial cable to get any output. However, it's a start.
> 
> >   msm: mahimahi: add mahimahi board file
> >   msm: mahimahi: add in mmc support code
> >   msm: mahimahi: add gpio pin muxing code
> >   msm: mahimahi: initialize mmc at start up
> 
> Even you call the machine Nexus One... can  you be a tiny bit more
> consistent with it?

I tried to call it Nexus One in this release note cause no one knows
what a "mahimahi" is .. I would like to call it Nexus One all over, but
I can't because Google uses the name mahimahi..

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

