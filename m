Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1LUTt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:49:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:51084 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1LUTt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:49:58 -0500
Message-ID: <1324496980.17070.1.camel@twins>
Subject: Re: [PATCH 0/4][RFC] jump label: introduce default true branch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        mingo@elte.hu, davem@davemloft.net, ddaney.cavm@gmail.com,
        pjt@google.com, rth@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 21 Dec 2011 20:49:40 +0100
In-Reply-To: <cover.1324493360.git.jbaron@redhat.com>
References: <cover.1324493360.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 14:09 -0500, Jason Baron wrote:
> Hi Peter,
> 
> I've introduced a new static_branch_def_true() construct, such that the straight
> line path is the true branch, and we patch a jump to get to the false branch.

> I think this patch series should address the issues that came up with sched_feat()
> implementation.

Nice trick, I've only casually read patch 1 because my brain gave up for
the day, but I'll have a closer look tomorrow.


