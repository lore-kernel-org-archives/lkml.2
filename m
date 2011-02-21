Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1BUDNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:13:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53438 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754498Ab1BUDN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:13:29 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+NwthNYgGNWoPSBIl5dcee3ud9wxLO2im2tvXtsN
	PJ3EEUOYrCe7w+
Subject: Re: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1298222533.7881.15.camel@marge.simson.net>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
	 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
	 <1298207379.7998.11.camel@marge.simson.net>  <20110220141003.GA6006@zhy>
	 <1298222533.7881.15.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 04:13:25 +0100
Message-ID: <1298258005.7853.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-20 at 18:22 +0100, Mike Galbraith wrote:
> On Sun, 2011-02-20 at 22:10 +0800, Yong Zhang wrote:
> > On Sun, Feb 20, 2011 at 02:09:39PM +0100, Mike Galbraith wrote:
> > > On Sun, 2011-02-20 at 15:08 +0800, Yong Zhang wrote:
> > > > Now enable/disable autogroup at runtime is just a flag,
> > > > it doesn't take effect on current process of the system.
> > > 
> > > Yup, they only move upon migration, which can take up to forever.
> > 
> > Yeah. so on UP, the user can have autogroup forever or not, and
> > sched_autogroup_enable is a nop.
> 
> Yup, and that's the best argument for doing the active switch.
> 
> > Apart from runtime enable/disable issue, I think patch1~3 could
> > still be applied beause they really fix some problem or bring
> > some improvement.
> 
> Yeah.
> 
> Your whole series looked fine to me at a glance (sunday;), with the
> exception of #2, that one is maybe iffy, depending on point of view.

Hm, my mind wandered off to different file somewhere along the line :)

	-Mike

