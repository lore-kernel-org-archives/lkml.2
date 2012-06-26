Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2FZKvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:51:40 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:59173 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422Ab2FZKvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:51:38 -0400
Message-ID: <4FE99432.8030300@ti.com>
Date: Tue, 26 Jun 2012 16:21:30 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Felipe Balbi <balbi@ti.com>, ben-linux@fluff.org,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/17] Big OMAP I2C Cleanup
References: <1339691067-919-1-git-send-email-balbi@ti.com> <20120614175950.GE14419@pengutronix.de>
In-Reply-To: <20120614175950.GE14419@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2012 11:29 PM, Wolfram Sang wrote:
>> 	- removed dev_err() which was introduced on patch 09/17
> To prevent the list being flooded, I would appreciate if you could wait
> a few days to collect reviews before resending. It will take some time
> until I pick this series anyhow, because I want people to have time to
> donate Tested-by tags.
Felipe thats a good cleanup.
The series look good to me.

Also draining interrupt I had some queries.
Looks good to me.

I have tested it after rebasing.
Tested-by : Shubhrajyoti <shubhrajyoti@ti.com>


Thanks,


