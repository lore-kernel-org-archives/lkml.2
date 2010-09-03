Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0ICNGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:06:36 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:32934 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325Ab0ICNGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:06:34 -0400
Message-ID: <4C80F2CD.2040708@euromail.se>
Date: Fri, 03 Sep 2010 15:06:21 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Ping Cheng <pingc@wacom.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] input: wacom: Add support for the Bamboo Touch trackpad
 (rev3)
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se> <1283516247-11624-4-git-send-email-rydberg@euromail.se> <6753EB6004AFF34FAA275742C104F952022BB10E@wacom-nt10.wacom.com>
In-Reply-To: <6753EB6004AFF34FAA275742C104F952022BB10E@wacom-nt10.wacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OrVyI-0002yh-8v.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OrVyI-0002yh-8v fedd72f7d21faf4c2602554ca8716f73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 03:01 PM, Ping Cheng wrote:
[...]

> +	input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
> +	input_report_key(input, BTN_MIDDLE, (data[1] & 0x04) != 0);
> +	input_report_key(input, BTN_4, (data[1] & 0x02) != 0);
> +	input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
> 
> Since you are assigning meaningful defaults to three of the tablet
> buttons instead of using BTN_#, can we move one more step to make the
> fourth button useful out-of-box too? I am thinking of something like
> BTN_FORWARD and BTN_BACK while getting rid of the BTN_MIDDLE. So, it
> would be:
> 
> 	input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
> 	input_report_key(input, BTN_FORWARD, (data[1] & 0x04) != 0);
> 	input_report_key(input, BTN_BACK, (data[1] & 0x02) != 0);
> 	input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
> 
> Does this make sense to you?


Well, this is all a matter of taste, isn't it. If middle-button emulation works
out of the box, for the benefit of us old X users who seem unwilling to ever let
go of the click-to-paste functionality, then I would not mind terribly.

Henrik
