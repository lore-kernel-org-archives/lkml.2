Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858Ab2EWBrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:47:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49985 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab2EWBrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:47:09 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-c5-4fbc419aaa10
To: undisclosed-recipients:;
Message-ID: <4FBC41A2.1080402@kernel.org>
Date: Wed, 23 May 2012 10:47:14 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] zsmalloc: use unsigned long instead of void *
References: <1337567013-4741-1-git-send-email-minchan@kernel.org> <4FBA4EE2.8050308@linux.vnet.ibm.com> <4FBC2916.5000305@kernel.org>
In-Reply-To: <4FBC2916.5000305@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 09:02 AM, Minchan Kim wrote:

> Maybe I will resend next spin based on v3.4 today
> I hope it doesn't hurt you.


I didn't based v2 patches on v3.4 because mainline tree doesn't have lots of staging patchset.
So it's not a good idea to apply staging patchset in mainline. I believe linux-next is good candidate
for it so I sent v2 patches against next-20120522.

Thanks.

-- 
Kind regards,
Minchan Kim
