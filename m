Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab1FTAov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 20:44:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58028 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab1FTAot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 20:44:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFE97F1.2030206@jp.fujitsu.com>
Date: Mon, 20 Jun 2011 09:44:33 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: david@fromorbit.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 01/12] vmscan: add shrink_slab tracepoints
References: <1306998067-27659-1-git-send-email-david@fromorbit.com> <1306998067-27659-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1306998067-27659-2-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/02 16:00), Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Іt is impossible to understand what the shrinkers are actually doing
> without instrumenting the code, so add a some tracepoints to allow
> insight to be gained.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/trace/events/vmscan.h |   67 +++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c                   |    6 +++-
>  2 files changed, 72 insertions(+), 1 deletions(-)

This look good to me. I have two minor request. 1) please change patch order,
move this patch after shrinker changes. iow, now both this and [2/12] have
tracepoint change. I don't like it. 2) please avoid cryptic abbreviated variable
names. Instead, please just use the same variable name with vmscan.c source code.


