Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2DZC7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:59:08 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:37664 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2DZC7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:59:06 -0400
MIME-Version: 1.0
In-Reply-To: <CANKRQnhW6bH2eok5LtrW0Qg2Dis5EpC9Sae6Le+9Chkv0yQA4w@mail.gmail.com>
References: <1334817485-7121-1-git-send-email-tomoya.rohm@gmail.com>
	<20120420203937.GB12691@pengutronix.de>
	<CANKRQnhW6bH2eok5LtrW0Qg2Dis5EpC9Sae6Le+9Chkv0yQA4w@mail.gmail.com>
Date: Thu, 26 Apr 2012 11:59:05 +0900
Message-ID: <CANKRQnh6Vgou1A+tNFd6SyNuzsCfpUGEGRxkV4jPunDYpTDgwQ@mail.gmail.com>
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

On Mon, Apr 23, 2012 at 1:25 PM, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
>>
>> My checkers found some other issues, for which I will send patches in a
>> minute. Please have a look and test.
>
> OK.
> I'll do until this week end and report to you.
>

These 4 patches posted by you don't affect this driver's logical behavior.
So, I only confirmed the driver is compiled without any error/warning.

thanks.
-- 
ROHM Co., Ltd.
tomoya
