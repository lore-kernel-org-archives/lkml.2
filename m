Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2A2UcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 15:32:14 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53440 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220Ab2A2UcM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 15:32:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAN_cFWMPNRx75GC0d0Z5CZC0dPH=wv1YVuA+7j4pfFh9ww9bgg@mail.gmail.com>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
	<201201261531.40551.arnd@arndb.de>
	<20120127162624.40cba14e.akpm@linux-foundation.org>
	<CAN_cFWMPNRx75GC0d0Z5CZC0dPH=wv1YVuA+7j4pfFh9ww9bgg@mail.gmail.com>
Date: Sun, 29 Jan 2012 22:32:11 +0200
Message-ID: <CAJL_dMtSArpbKXA3xGdsBH=j0L8m_SnpK=WPX+s5DqdU0OaJhA@mail.gmail.com>
Subject: Re: [PATCHv19 00/15] Contiguous Memory Allocator
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Rob Clark <rob.clark@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Also there is the supreme tag: "Tested-by:.".  Ohad (at least) has been
>> testing the code.  Let's mention that.
>>
>
> fyi Marek, I've been testing CMA as well, both in context of Ohad's
> rpmsg driver and my omapdrm driver (and combination of the two)..  so
> you can add:
>
> Tested-by: Rob Clark <rob.clark@linaro.org>
>
> And there are some others from linaro that have written a test driver,
> and various stress test scripts using the test driver.  I guess that
> could also count for some additional Tested-by's.

Convince them to report with Tested-by tag.
This is a first step for them to face the open source.
