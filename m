Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0DXCaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:30:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51929 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752562Ab0DXCau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:30:50 -0400
Date: Fri, 23 Apr 2010 22:30:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/9] PM: Add suspend block api.
In-Reply-To: <p2vd6200be21004231915o5b2d4ed1zbabd3e51e6213f45@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004232224380.30686-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Arve Hjønnevåg wrote:

> 2010/4/23 Alan Stern <stern@rowland.harvard.edu>:
> > On Thu, 22 Apr 2010, [UTF-8] Arve Hjønnevåg wrote:
> ...
> >> +Calling suspend_block when the suspend blocker is active or suspend_unblock when
> >> +it is not active has no effect. This allows drivers to update their state and
> >> +call suspend suspend_block or suspend_unblock based on the result.
> >
> > But suspend_block() and suspend_unblock() don't nest.  You should
> > mention this.
> >
> 
> I'm not sure what you mean by this? I think the first sentence
> dictates nesting is not supported.

That fact is implicit from the first sentence.  Mentioning it 
_explicitly_ will help people to understand more easily.  You don't 
have to add much; a parenthetical remark would be enough:

	Calling suspend_block when the suspend blocker is active or
	suspend_unblock when it is not active has no effect (i.e.,
	these functions don't nest).  This allows drivers to ...

Alan Stern

