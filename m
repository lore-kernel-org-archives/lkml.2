Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab1JZUPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:15:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57815 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1JZUPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:15:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 26 Oct 2011 22:15:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        carla.sella@gmail.com
Cc: linux-kernel@vger.kernel.org, Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: reporting a bug
Message-ID: <20111026221507.13f705ee@stein>
In-Reply-To: <20111026215109.24e0e737@neptune.home>
References: <4EA8641C.2010905@gmail.com>
	<20111026215109.24e0e737@neptune.home>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 26 Bruno Prémont wrote:
> On Wed, 26 October 2011 Carla Sella <carla.sella@gmail.com> wrote:
> > Hello, My name is Carla and I'm member of the Ubuntu laptop testing team.
> > I was asked to report a bug upstream on bugzilla.kernel.org.
> > As bugzilla.kernel.org is down, must I wait for it to be restored or is
> > there an alternative way to report a bug ?
> > Thank you.
> 
> The alternative is to report the bug here, CCing the appropriate
> subsystem lists (and later filing the bug under bugzilla once it comes
> back - if needed)

Even when bugzilla.kernel.org was functional, the better way to report
kernel bugs was widely regarded to post at LKML (and any appropriate
subsystem mailinglist).  Many (?) developers consider bugzilla.kernel.org
to be a _tracking_ tool rather than a reporting tool.  Some developers did
not like to interact with bugzilla.kernel.org at all.

I too think that bug reporting and bug tracking are not entirely the same,
and that LKML (or kernel subsystem mailinglists, respectively) are
usually preferable for bug reporting.
-- 
Stefan Richter
-=====-==-== =-=- ==-=-
http://arcgraph.de/sr/
