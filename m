Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2AWKm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 05:42:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41409 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2AWKm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 05:42:56 -0500
Date: Mon, 23 Jan 2012 10:42:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Harini Jayaraman <harinij@codeaurora.org>
Cc: grant.likely@secretlab.ca, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kheitke@codeaurora.org, spi-devel-general@lists.sourceforge.net,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] spi: QUP based bus driver for Qualcomm MSM chipsets
Message-ID: <20120123104220.GV1068@n2100.arm.linux.org.uk>
References: <y> <1321307907-31508-1-git-send-email-harinij@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321307907-31508-1-git-send-email-harinij@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not specific to this patch, but I notice that you have in your headers:

In-Reply-To: <y>
References: <y>

This is rather annoying, because it means that anyone else who has the
same lines ends up having their messages attached to your messages as
part of the same thread.

I think you need to read the documentation for git-send-email again -
and check that you're using the arguments concerning message ids and
threading correctly.

Thanks.
