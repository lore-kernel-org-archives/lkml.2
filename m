Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab1DNJQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:16:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab1DNJQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:16:14 -0400
Subject: Re: [tip:sched/locking] sched: Move wq_worker_waking to the
 correct site
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1302772466.2388.133.camel@twins>
References: <tip-c2f7115e2e52a6c187b8c1f54f0e4970bb677be0@git.kernel.org>
	 <1302772466.2388.133.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Apr 2011 11:15:52 +0200
Message-ID: <1302772552.2388.134.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 11:14 +0200, Peter Zijlstra wrote:
> 
> > Link:
> http://lkml.kernel.org/n/top-t3m7n70n9frmv4pv2n5fwmov@git.kernel.org
> 
> hpa, that Link: magic doesn't appear to have done the trick.. 

Damn, I fat fingered things.. I wrote n/top-

/me goes fix
