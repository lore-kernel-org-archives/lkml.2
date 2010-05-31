Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0EaKHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:07:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:47293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab0EaKHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:07:45 -0400
Message-ID: <4C038A59.4020709@kernel.org>
Date: Mon, 31 May 2010 12:07:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 4/4] sched: add hooks for workqueue
References: <1273747705-7829-1-git-send-email-tj@kernel.org>	 <1273747705-7829-5-git-send-email-tj@kernel.org>	 <1275292867.27810.21442.camel@twins>  <4C038841.1010507@kernel.org> <1275300358.27810.21869.camel@twins>
In-Reply-To: <1275300358.27810.21869.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 10:07:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 12:05 PM, Peter Zijlstra wrote:
> That again only explains what you use the sleep hook for, not what you
> want to use the wakeup hook for (putting a worker to sleep when there
> are now 2 runnable seems like a good use).

Alright, will add that.  Thanks.

-- 
tejun
