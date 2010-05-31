Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0EaKPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:15:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:53018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab0EaKO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:14:59 -0400
Subject: Re: [PATCH 2/4] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <4C038A08.8090209@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
	 <1273747705-7829-3-git-send-email-tj@kernel.org>
	 <1275292866.27810.21441.camel@twins>  <4C03879A.8030505@kernel.org>
	 <1275300084.27810.21850.camel@twins> <1275300165.27810.21858.camel@twins>
	 <4C038A08.8090209@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 12:15:04 +0200
Message-ID: <1275300904.27810.21907.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 12:06 +0200, Tejun Heo wrote:
>  I meant CPU_ONLINE not CPU_UP_PREPARE.  So,
> we can mark a cpu active before other CPU_ONLINE callbacks are run.

OK, that should work.
