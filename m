Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab0JSJ05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:26:57 -0400
Received: from canuck.infradead.org ([134.117.69.58]:58026 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab0JSJ04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:26:56 -0400
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1287479765.9920.9.camel@marge.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 11:26:31 +0200
Message-ID: <1287480391.29097.1647.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 11:16 +0200, Mike Galbraith wrote:
> Greetings,
> 
> Comments, suggestions etc highly welcome.

You might be wanting to exclude RT tasks from the tty groups since there
is no interface to grant them any runtime and such :-)

Also, I think tty_sched_move_task and sched_move_task() should be
sharing lots more code -- I recently proposed a fix for
sched_move_task() because the Android people complained, but they
haven't replied back yet..

