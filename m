Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161085Ab2GLOBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:01:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:51289 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab2GLOBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:01:10 -0400
Message-ID: <1342101655.28010.1.camel@twins>
Subject: Re: [RFC PATCH] sched: add load balance cpumask pointer into lb_env
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Date: Thu, 12 Jul 2012 16:00:55 +0200
In-Reply-To: <4FFE8665.3080705@linux.vnet.ibm.com>
References: <4FFE8665.3080705@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 16:10 +0800, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> with this patch, ld_env will have a pointer of load balance cpumask,
> and we don't need to pass cpus anymore.


Thanks!
