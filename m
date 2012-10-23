Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2JWHn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:43:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45026 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2JWHnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:43:25 -0400
X-AuditID: cbfee61b-b7f616d00000319b-dd-50864a9b0f3c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Marek Vasut'" <marex@denx.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000a01cdb0d5$9d764970$d862dc50$%han@samsung.com>
 <201210230934.51274.marex@denx.de>
In-reply-to: <201210230934.51274.marex@denx.de>
Subject: Re: [PATCH 2/4] backlight: lms283gf05: add missing const
Date: Tue, 23 Oct 2012 16:43:23 +0900
Message-id: <000401cdb0f2$14a515f0$3def41d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w8OaJTNqheMgmSSWRnRV4Hm2/8AAAL8qQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd05Xm0BBlcPsllc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MI3s2sxTMY6lYPuEySwPjfOYuRk4OCQETie0bL7JC2GISF+6t
	ZwOxhQSmM0r8uVHYxcgFZM9mktiydgtYA5uAmsSXL4fZQWwRAUWJNefnM4IUMQssYZSY8/IT
	kMMB1JEksfiRA0gNp4C+xI+m62wgYWEBR4nDmzNBwiwCqhJzD+8G28srYCtx+fomZghbUOLH
	5HssIDazgJbE+p3HmSBseYnNa94yg4yREFCXePRXF+ICI4kb744zQ5SISOx78Y5xAqPQLCST
	ZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7iZ9I7GFc1WBxiFOBg
	VOLh7djfGiDEmlhWXJl7iFGCg1lJhNfUvi1AiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qA
	kEB6YklqdmpqQWoRTJaJg1OqgTFC4Bfr326Bk1vNf87Sf9Zs7nwikLd1/9WmSZxOUiZaSg7C
	oqyLF12qejj7bsiLzWwLGtdLZhst3y3gWvTu4psZ57e5/jaXvLDHg8317eTl0ltFT03zt/tw
	0/7uYYVnXTHWixzipfSUqtUcl9R1zdUrv6LgXLTtVdY8rcpVvNdN6l9e+7JFuUuJpTgj0VCL
	uag4EQB0tlavXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 23, 2012 4:35 PM Marek Vasut wrote
> 
> Dear Jingoo Han,
> 
> > Add 'const' to static array that was missing it in its
> > definition.
> 
> Did you get compiler warning? Still, this is a good pick

No, I didn't get compiler warning. :)
Thank you for your reply.

> 
> Acked-by: Marek Vasut <marex@denx.de>
> 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Marek Vasut <marek.vasut@gmail.com>
> > Cc: Richard Purdie <rpurdie@rpsys.net>
> > ---
> [...]
> 
> Best regards,
> Marek Vasut

