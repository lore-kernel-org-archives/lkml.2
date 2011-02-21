Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1BUQg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:36:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:53255 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1BUQg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:36:27 -0500
Subject: Re: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1298222533.7881.15.camel@marge.simson.net>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
	 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
	 <1298207379.7998.11.camel@marge.simson.net>  <20110220141003.GA6006@zhy>
	 <1298222533.7881.15.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 21 Feb 2011 17:36:15 +0100
Message-ID: <1298306175.24121.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-20 at 18:22 +0100, Mike Galbraith wrote:
> 
> Your whole series looked fine to me at a glance (sunday;), with the
> exception of #2, that one is maybe iffy, depending on point of view.

Right, so I've queued 1 and 3, 2 is like you said iffy, if there's an
autogroup it should display it.

As to 5, I really don't care, Linus did seem to care initially, don't
know how he feels about it now.
