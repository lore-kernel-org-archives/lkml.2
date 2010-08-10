Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab0HJTVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:21:31 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48377 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab0HJTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:21:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6070"; a="50417014"
Message-ID: <821ba2d399d553ea5f0398ef7b94e464.squirrel@www.codeaurora.org>
In-Reply-To: <1281418597.1954.106.camel@Joe-Laptop.home>
References: <1281407259-28626-1-git-send-email-stepanm@codeaurora.org>
    <1281409689.1954.96.camel@Joe-Laptop.home>
    <bf2b5539fdb03a1a9c55ee1122c40b99.squirrel@www.codeaurora.org>
    <1281418597.1954.106.camel@Joe-Laptop.home>
Date: Tue, 10 Aug 2010 12:22:08 -0700 (PDT)
Subject: Re: [PATCH v3] arm: msm: Add MSM IOMMU support.
From: stepanm@codeaurora.org
To: "Joe Perches" <joe@perches.com>
Cc: stepanm@codeaurora.org, linux-arm-msm@vger.kernel.org,
        dwalker@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2010-08-09 at 20:42 -0700, stepanm@codeaurora.org wrote:
> I believe the current uses of pr_err in this module
> are unnecessary or could be converted to pr_debug.
>
> I think __func__/line aren't particularly useful.
>
> I prefer log messages prefixed with the module name.
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> and I'd convert all the current pr_err to pr_debug
> and convert the printk(KERN_ERR to pr_err(
>
> cheers, Joe

Thanks. Fixed in v4, which will go up in a few minutes.

