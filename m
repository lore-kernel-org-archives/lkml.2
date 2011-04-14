Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab1DNJOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:14:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab1DNJOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:14:51 -0400
Subject: Re: [tip:sched/locking] sched: Move wq_worker_waking to the
 correct site
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-c2f7115e2e52a6c187b8c1f54f0e4970bb677be0@git.kernel.org>
References: <tip-c2f7115e2e52a6c187b8c1f54f0e4970bb677be0@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Apr 2011 11:14:26 +0200
Message-ID: <1302772466.2388.133.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 08:32 +0000, tip-bot for Peter Zijlstra wrote:

> Message-ID: <tip-c2f7115e2e52a6c187b8c1f54f0e4970bb677be0@git.kernel.org>

> Link: http://lkml.kernel.org/n/top-t3m7n70n9frmv4pv2n5fwmov@git.kernel.org

hpa, that Link: magic doesn't appear to have done the trick..
