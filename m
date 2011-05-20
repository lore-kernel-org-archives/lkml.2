Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852Ab1ETUYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:24:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934278Ab1ETUYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:24:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ray Lee <ray-lk@madrabbit.org>
Subject: Re: Major 2.6.38 regression ignored?
Date: Fri, 20 May 2011 22:24:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: "Luke-Jr" <luke@dashjr.org>, chris@chris-wilson.co.uk,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com>
In-Reply-To: <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105202224.56867.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 20, 2011, Ray Lee wrote:
> [ Adding Chris Wilson (author of the problematic patch) and Rafael Wysocki
> to the message ]

It is on the list of known regressions from 2.6.37, but we're not tracking
them any more now that 2.6.39 is out.

Thanks,
Rafael


> On Fri, May 20, 2011 at 10:06 AM, Luke-Jr <luke@dashjr.org> wrote:
> 
> > I submitted https://bugzilla.kernel.org/show_bug.cgi?id=33662 a month ago
> > against 2.6.38. Now 2.6.39 was just released without the regression being
> > addressed. This bug makes the system unusable... Some guys on IRC suggested
> > I
> > email, so here it is.
> >
> 
> See the bugzilla entry for the bisection history.
> 
> ~r.
> 

