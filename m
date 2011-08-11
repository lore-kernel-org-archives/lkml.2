Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1HKSDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab1HKSDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:03:30 -0400
Message-ID: <4E4408FA.7010806@redhat.com>
Date: Thu, 11 Aug 2011 12:53:14 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/7] xfs: Warn if direct reclaim tries to writeback pages
References: <1312973240-32576-1-git-send-email-mgorman@suse.de> <1312973240-32576-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1312973240-32576-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 06:47 AM, Mel Gorman wrote:
> Direct reclaim should never writeback pages. For now, handle the
> situation and warn about it. Ultimately, this will be a BUG_ON.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

