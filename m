Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1GMU67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:58:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52469 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1GMU66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:58:58 -0400
Subject: Re: [PATCH 0/6] Small scheduling cleanups
From: Peter Zijlstra <peterz@infradead.org>
To: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 22:58:43 +0200
Message-ID: <1310590723.2586.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 20:13 +0200, Jan H. Schönherr wrote:
> Hi Ingo, hi Peter.
> 
> While working with the scheduling subsystem, our code review showed some
> things you might be interested in.
> 
> This series is based on v3.0-rc7.
> 
> 
> Patch 1 fixes a typo.
> 
> Patch 2 drops an unused function.
> 
> Patch 3 and 4 avoid some redundancy during runqueue initialization.
> While not stricly necessary, the code is a bit cleaner afterwards.
> 
> Patch 5 replaces a loop over all task group with a loop over the
> leaf CFS runqueues.
> 
> And patch 6 finally avoids a potential crash if there is suddenly no
> memory during task group creation.

Applied 1,2 and 6. Thanks!
