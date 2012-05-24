Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2EXNUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:20:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59854 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2EXNUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:20:45 -0400
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on
 westmere
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
In-Reply-To: <1337865431.9783.148.camel@laptop>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 15:20:41 +0200
Message-ID: <1337865641.9783.149.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 15:17 +0200, Peter Zijlstra wrote:
> For power7 with 4 smt it would end up as 1230 I guess.

One more thing, in light of that, can't you simplify the core stuff to
be a simple shift as well? map them 123450, does it really matter to
pair them off like 103254 ?

