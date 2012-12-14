Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2LNBUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:20:41 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:55279 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab2LNBUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:20:40 -0500
Message-ID: <50CA7EE4.3000306@linaro.org>
Date: Thu, 13 Dec 2012 17:20:36 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
In-Reply-To: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 06:05 PM, Feng Tang wrote:
> In current kernel, there are several places which need to check
> whether there is a persistent clock for the platform. Current check
> is done by calling the read_persistent_clock() and validating the
> return value.
>
> Add such a flag to make code more readable and call read_persistent_clock()
> only once for all the checks.
Sorry.. What  the actual benefit of this patch set?   (Usually with 
changelogs its better to explain why you're doing something, rather then 
just what you're doing.)

Maybe I'm missing something, but it seems this doesn't change the 
resulting logic of the code, does it?  As I thought we already check 
read_persistent_clocks() output (and make sure its null) before using 
the rtc HCTOSYS_DEVICE.

thanks
-john

