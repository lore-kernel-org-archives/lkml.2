Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab1KVLAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:00:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1KVLAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:00:07 -0500
Message-ID: <1321959598.5148.24.camel@twins>
Subject: Re: [PATCH RFC] perf, core: disable pmu while context rotation only
 if needed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Date: Tue, 22 Nov 2011 11:59:58 +0100
In-Reply-To: <20111122105625.GC2557@redhat.com>
References: <20111115113414.GD3225@redhat.com>
	 <1321358833.1421.62.camel@twins> <20111115123814.GE3225@redhat.com>
	 <1321361719.1421.67.camel@twins> <20111122105625.GC2557@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 12:56 +0200, Gleb Natapov wrote:
> Have you committed it somewhere? I do not see it in tip.git, but may be
> I am looking in a wrong place. 

Its still in my queue, I guess I should poke mingo again to pick up.
Also, I really ought to get my k.org account back up and write a script
to push this queue of mine into a git tree for ease of use.

For now you can have a peek at it through:

http://programming.kicks-ass.net/sekrit/patches.tar.bz2


