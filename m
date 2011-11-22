Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1KVOMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:12:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:34976 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab1KVOMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:12:15 -0500
Message-ID: <1321971130.14799.11.camel@twins>
Subject: Re: [PATCH] perf,core: do no try to schedule task events if there
 are none.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Tue, 22 Nov 2011 15:12:10 +0100
In-Reply-To: <20111122140821.GF2557@redhat.com>
References: <20111122140821.GF2557@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 16:08 +0200, Gleb Natapov wrote:
> The patch is against tip/perf/urgent since it depends on commit
> 1d5f003f5a9 there.  I've sent updated version of above commit earlier but
> unfortunately old version was applied and I do not see amended version
> in Peter's queue either. So here is incremental fix.

Ah, sorry for messing that up, I did pick up the new version, but must
have crossed wires with Ingo merging and I failed to double check which
version ended up in the tree.

Thanks!
