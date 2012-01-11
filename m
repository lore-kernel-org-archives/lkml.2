Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab2AKQoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:44:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:45683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2AKQo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:44:29 -0500
Message-ID: <1326300264.2442.162.camel@twins>
Subject: Re: [Question] sched: Should balance_iterator be removed?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jan 2012 17:44:24 +0100
In-Reply-To: <CADZ9YHgCc3T1oPJ717+=2CGODqz715qCzwvEobh8yBur4E80Eg@mail.gmail.com>
References: <CADZ9YHgCc3T1oPJ717+=2CGODqz715qCzwvEobh8yBur4E80Eg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 22:10 +0600, Rakib Mullick wrote:
> Hello all,
> 
> Commit 4a55bd5e97b1775913 (sched: fair-group: de-couple load-balancing
> from the rb-trees) added balance_iterator in cfs_rq. But, no real use
> in current code. Shouldn't it be removed? Or has it been kept for
> future use?

Nope its dead wood, thanks for spotting it.
