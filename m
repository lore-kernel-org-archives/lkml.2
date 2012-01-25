Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2AYMdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:33:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40822 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2AYMdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:33:07 -0500
Subject: Re: [PATCH] sched: Remove sched_switch completely from runqueue
 structure.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1327422836.27181.5.camel@localhost.localdomain>
References: <1327422836.27181.5.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 13:33:00 +0100
Message-ID: <1327494780.2614.60.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 22:33 +0600, Rakib Mullick wrote:
> Currently we don't utilize sched_switch field properly for counting
> context switch numbers. We can remove it.
> But, simply removing sched_switch field from sched_stat output will
> break ABI integrity. So, we make sure 
> /proc/sched_stat output remains as it is by hardcoding zero in place
> of sched_switch field's output and remove
> sched_switch from sched_debug output too. And update scheduler-stat
> documentation accordingly.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com> 

Thanks

