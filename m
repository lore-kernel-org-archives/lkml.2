Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031634Ab2CGAoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:44:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37786 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab2CGAoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:44:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120306145817.GA2947@kroah.com>
References: <20120305164308.GE2459@kroah.com>
	<1331002144-30113-1-git-send-email-tomoya.rohm@gmail.com>
	<CANKRQng9mXsotS=Lq9QwwmXWEdfrwPUcTdxvjOf56uXe7APMiQ@mail.gmail.com>
	<20120306145817.GA2947@kroah.com>
Date: Wed, 7 Mar 2012 09:44:00 +0900
Message-ID: <CANKRQngxkS9am4BqTSiJXTugH3OBdjzGnmhrqOnKN_4GpTn9Og@mail.gmail.com>
Subject: Re: [PATCH][linux-next][RESEND] usb/gadget/pch_udc: Fix compile error
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 11:58 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>> Additionally, this driver is for companion chip of Intel Atom E6xx series.
>> So, this driver is never used for except x86, e.g. sparc.
>
> Then the Kconfig file should probably only enable it on x86 to prevent
> these kinds of things :)

Yes, you are right.
I should have added "x86" to Kconfig.

thanks,
-- 
ROHM Co., Ltd.
tomoya
