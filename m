Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab2F2Gbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 02:31:32 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51698 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab2F2Gbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 02:31:31 -0400
Message-ID: <4FED4BB7.6070706@ti.com>
Date: Fri, 29 Jun 2012 12:01:19 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: Re: [PATCH v2] clk: Add support for rate table based dividers
References: <1340794893-20869-1-git-send-email-rnayak@ti.com> <20120627162851.GT1623@pengutronix.de> <20120627180635.GH22766@gmail.com>
In-Reply-To: <20120627180635.GH22766@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> After thinking about it a bit more I still think a separate
> clk_register_divider_table is needed.  Primarily this would reduce
> needless churn in having to update all existing users of
> clk_register_divider.  I also think that clearly separating the two
> functions will make it a bit easier on folks trying to port their clocks
> trees over.
>
> Unless there is a technical reason why having two registration functions
> is a bad idea, can you send a V4 with that new registration function?
> I'll take it into clk-next.
>
Nope, no technical reason why it can't be done. I'll do what you
suggested and post a v4 soon.

thanks,
Rajendra
