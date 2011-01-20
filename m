Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1ATSHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:07:55 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:50259 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1ATSHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:07:54 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 3/5] RTC: Rework RTC code to use timerlist for events
References: <1290136329-18291-1-git-send-email-john.stultz@linaro.org>
	<1290136329-18291-4-git-send-email-john.stultz@linaro.org>
X-Yow: ... I live in a FUR-LINE FALLOUT SHELTER
Date: Thu, 20 Jan 2011 19:07:50 +0100
In-Reply-To: <1290136329-18291-4-git-send-email-john.stultz@linaro.org> (John
	Stultz's message of "Thu, 18 Nov 2010 19:12:07 -0800")
Message-ID: <m2hbd378jt.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> This patch reworks a large portion of the generic RTC code
> to in-effect virtualize the rtc interrupt code.

That breaks RTC on powermac which uses rtc-generic.

# hwclock 
select() to /dev/rtc0 to wait for clock tick timed out

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
