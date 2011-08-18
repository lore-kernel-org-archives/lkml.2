Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1HRX1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 19:27:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293Ab1HRX1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 19:27:31 -0400
Date: Thu, 18 Aug 2011 16:27:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Boyer <jwboyer@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-Id: <20110818162723.aa63bc38.akpm@linux-foundation.org>
In-Reply-To: <20110818231646.GH2325@linux.vnet.ibm.com>
References: <20110815152052.GA2389@linux.vnet.ibm.com>
	<20110817223735.GI2227@zod.bos.redhat.com>
	<20110817224916.GO2419@linux.vnet.ibm.com>
	<20110817230219.GJ2227@zod.bos.redhat.com>
	<20110817230641.GA7837@somewhere.redhat.com>
	<20110817231750.GK2227@zod.bos.redhat.com>
	<20110818183523.GD2325@linux.vnet.ibm.com>
	<20110818140034.668e8dea.akpm@linux-foundation.org>
	<20110818212334.GE2325@linux.vnet.ibm.com>
	<20110818221920.GR2227@zod.bos.redhat.com>
	<20110818231646.GH2325@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 16:16:46 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Andrew, are you willing to ack this?

WhoMeNope.  That would imply that I understood it, but my brain is far
too small to understand rcutree.c - that's what we have paulmcks for.
