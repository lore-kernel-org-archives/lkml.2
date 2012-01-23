Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab2AWP6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:58:54 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48198 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2AWP6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:58:53 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6597"; a="157242199"
Date: Mon, 23 Jan 2012 07:58:51 -0800
From: David Brown <davidb@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Harini Jayaraman <harinij@codeaurora.org>, grant.likely@secretlab.ca,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kheitke@codeaurora.org,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] spi: QUP based bus driver for Qualcomm MSM chipsets
Message-ID: <20120123155851.GA25417@codeaurora.org>
References: <y>
 <1321307907-31508-1-git-send-email-harinij@codeaurora.org>
 <20120123104220.GV1068@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123104220.GV1068@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 10:42:20AM +0000, Russell King - ARM Linux wrote:
> Not specific to this patch, but I notice that you have in your headers:
> 
> In-Reply-To: <y>
> References: <y>
> 
> This is rather annoying, because it means that anyone else who has the
> same lines ends up having their messages attached to your messages as
> part of the same thread.
> 
> I think you need to read the documentation for git-send-email again -
> and check that you're using the arguments concerning message ids and
> threading correctly.

More specifically, when git-send-email promps for an email address or
a message id, realize it's not asking a yes or not question.  The
default it prints in brackets is what you get if you press enter.  If
you press 'y', the reply will be from 'y' as seen here.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
