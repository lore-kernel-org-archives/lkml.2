Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab2DWEZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 00:25:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46307 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2DWEZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120420203937.GB12691@pengutronix.de>
References: <1334817485-7121-1-git-send-email-tomoya.rohm@gmail.com>
	<20120420203937.GB12691@pengutronix.de>
Date: Mon, 23 Apr 2012 13:25:03 +0900
Message-ID: <CANKRQnhW6bH2eok5LtrW0Qg2Dis5EpC9Sae6Le+9Chkv0yQA4w@mail.gmail.com>
Subject: Re: [PATCH 1/2] i2c-eg20t: add helper function for xfer check
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 5:39 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Thu, Apr 19, 2012 at 03:38:04PM +0900, Tomoya MORINAGA wrote:
>> Currently, there are the same code for xfer complete check processing.
>> So, I add helper function pch_i2c_wait_for_check_xfer.
>>
>> Reported-by: Wolfram Sang <w.sang@pengutronix.de>
>> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
>
> Both applied to next, thanks for doing this! ~120 lines saved, that's
> about 10%. And also way better maintainable, yay.

Thank you for your applied.

>
> My checkers found some other issues, for which I will send patches in a
> minute. Please have a look and test.

OK.
I'll do until this week end and report to you.

thanks,

-- 
ROHM Co., Ltd.
tomoya
