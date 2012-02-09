Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab2BITbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:31:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42856 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758377Ab2BITbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:31:09 -0500
Message-ID: <4F341F40.3020806@linaro.org>
Date: Thu, 09 Feb 2012 11:32:16 -0800
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: clock_getres() and real resolution
References: <4F32A347.4090703@linaro.org> <20120209051218.GC2211@netboy.at.omicron.at> <4F33910D.2030409@linaro.org> <20120209184019.GA2217@netboy.at.omicron.at>
In-Reply-To: <20120209184019.GA2217@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 10:40 AM, Richard Cochran wrote:

> I thought this list was about Linux kernel development, but now it
> seems to be about Sun's old bugs.

This Sun (probably) has ~100000x more accurate hrtimers than it's said,
and it's a bug. My panda board (with 32K timer enabled) has ~30000x
less accurate hrtimers than it's said, and it's not a bug. Great.

Dmitry
