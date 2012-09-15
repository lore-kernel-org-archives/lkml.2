Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2IOBHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 21:07:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38807 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab2IOBHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 21:07:47 -0400
Message-ID: <5053D4DB.30408@linaro.org>
Date: Fri, 14 Sep 2012 18:07:39 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] Remove jiffies clocksource's dependency on CLOCK_TICK_RATE
References: <1347671130-22095-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1347671130-22095-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12091501-6078-0000-0000-00000F875742
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 06:05 PM, John Stultz wrote:
> Just wanted to send this out for initial review and comments.

Gah. And I forgot to add the [RFC] header to my mails to make this 
clear.  Hopefully this doesn't confuse anyone.

These are not yet ready for submission! Just wanting feedback on the 
approach!

thanks
-john

