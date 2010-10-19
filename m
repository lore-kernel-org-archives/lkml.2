Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab0JSJnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:43:25 -0400
Received: from canuck.infradead.org ([134.117.69.58]:35046 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0JSJnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:43:24 -0400
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1287481199.24189.5.camel@marge.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287480391.29097.1647.camel@twins>
	 <1287481199.24189.5.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 11:43:01 +0200
Message-ID: <1287481381.29097.1652.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 11:39 +0200, Mike Galbraith wrote:
> 
> Yeah. I should be able to just do sched_move_task(), but it doesn't
> currently work even with your patch, turning tty_sched on/off can lead
> to incredible delays before you get box back.  With virgin source, it's
> size infinity for all intents and purposes.

Ah, first feedback I've got on that patch,. but surely since you created
one that does work we can fix my patch and use the normal path? :-)
