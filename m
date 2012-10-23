Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2JWOFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:05:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59923 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab2JWOFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:05:39 -0400
Date: Tue, 23 Oct 2012 16:05:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 16/34] perf, x86: Support weight samples for PEBS
Message-ID: <20121023140538.GH16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-17-git-send-email-andi@firstfloor.org> <1350998110.13456.26.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350998110.13456.26.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks like it will interfere with Stephane's LL patches -- which
> should be out any day now ;-)

To be honest I'm tired of waiting for them. They have been vapourware
for far too long.

I would have rebased on his, but since he never posts (and I do) 
I think it's reasonable now to require him to rebase on mine.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
