Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab0EDRLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:11:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab0EDRLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:11:35 -0400
Subject: Re: [PATCH 01/12] sched: drop @cpu argument from sched_in preempt
 notifier
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1272976724-14312-2-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272976724-14312-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 19:11:31 +0200
Message-ID: <1272993091.1642.185.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 14:38 +0200, Tejun Heo wrote:
> @cpu parameter is superflous.  Drop it.  This will help unifying
> notifiers in sched.

This seems sensible enough.

