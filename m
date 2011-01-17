Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab1AQNYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 08:24:51 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58847 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab1AQNYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 08:24:50 -0500
Subject: Re: [PATCH] sched: replace rq->bkl_count with
 rq->rq_sched_info.bkl_count
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1294991859-13246-1-git-send-email-yong.zhang0@gmail.com>
References: <1294991859-13246-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 14:25:27 +0100
Message-ID: <1295270727.30950.100.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 15:57 +0800, Yong Zhang wrote:
> Now rq->rq_sched_info.bkl_count is not used for rq, scroll
> rq->bkl_count into it. Thus we can save some space for rq.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>


Thanks, applied
