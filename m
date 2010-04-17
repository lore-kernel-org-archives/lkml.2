Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0DQTzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:55:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab0DQTzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:55:21 -0400
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
From: Peter Zijlstra <peterz@infradead.org>
To: tytso@mit.edu
Cc: Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
In-Reply-To: <20100417170808.GE32634@thunk.org>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	 <1271317886.32749.69.camel@laptop>  <20100417170808.GE32634@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Apr 2010 21:51:28 +0200
Message-ID: <1271533888.1674.486.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-17 at 13:08 -0400, tytso@mit.edu wrote:
> I think it's well understood
> that when these patches are ready to be merged, they need to be
> submitted right before the merge window opens, against a recent -rc
> kernel. 

No, they need to be in the relevant subsystem tree by then, patch
submissions to subsystem trees right before the merge window opens are
bound to get delayed another cycle.

