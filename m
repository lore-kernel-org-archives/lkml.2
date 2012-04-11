Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab2DKSEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:04:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2392 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2DKSEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:04:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6677"; a="178457633"
Date: Wed, 11 Apr 2012 11:04:09 -0700
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: msm: remove unused MSM boards
Message-ID: <20120411180408.GA12930@codeaurora.org>
References: <1334165870-12487-1-git-send-email-davidb@codeaurora.org>
 <20120411175550.GB8114@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411175550.GB8114@fifo99.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 10:55:50AM -0700, Daniel Walker wrote:
> On Wed, Apr 11, 2012 at 10:37:50AM -0700, David Brown wrote:
> > The "mahimahi" and "sapphire" were never finished, and have never been
> > built.
> > 
> > The "halibut" target was a dev board that hasn't ever been widely
> > available (MSM7201 "SURF").
> 
> I don't mind if you remove halibut, but the others are just incomplete
> phone support which someone may want to add to.. I'd prefer to fix those
> two..

Why, though?  It's obvious that nobody is using them, since they've
never worked.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
