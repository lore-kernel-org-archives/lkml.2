Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab0JUK2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:28:47 -0400
Received: from canuck.infradead.org ([134.117.69.58]:41754 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0JUK2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:28:46 -0400
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1287647741.9021.2.camel@marge.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287480391.29097.1647.camel@twins>
	 <1287481199.24189.5.camel@marge.simson.net>
	 <1287481381.29097.1652.camel@twins>
	 <1287647741.9021.2.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Oct 2010 12:28:29 +0200
Message-ID: <1287656909.3488.101.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 09:55 +0200, Mike Galbraith wrote:
> Actually, your patch works just peachy, my fiddling with sleepers
> vruntime at attach time was a dainbramaged thing to do. 

OK, I'll queue it with a Tested-by from you. Thanks!
