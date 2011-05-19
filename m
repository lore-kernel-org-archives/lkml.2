Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1ESL6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:58:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55904 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1ESL6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:58:54 -0400
Subject: Re: [RFC][PATCH] sched: Fix min_vruntime calculation in
 dequeue_entity
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dima Zavin <dima@android.com>
In-Reply-To: <1305674470-23727-1-git-send-email-john.stultz@linaro.org>
References: <1305674470-23727-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 May 2011 13:58:36 +0200
Message-ID: <1305806316.2466.7221.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 16:21 -0700, John Stultz wrote:
> While Dima never replied publicly, I bugged him a few weeks ago
> and he said that this fix should address his original issue.

Should or does? :-)

I was really hoping for a tested-by tag..
