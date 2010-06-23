Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0FWVY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:24:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43527 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab0FWVYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:24:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: Suspend hangs since 2.6.34
Date: Wed, 23 Jun 2010 23:22:57 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <20100621213224.GA5723@mac.home> <Pine.LNX.4.44L0.1006211828090.1687-100000@iolanthe.rowland.org> <20100623203234.GA20913@mac.home>
In-Reply-To: <20100623203234.GA20913@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006232322.57834.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 23, 2010, Tino Keitel wrote:
> On Mon, Jun 21, 2010 at 18:31:57 -0400, Alan Stern wrote:
> 
> [...]
> 
> > Why does this look like a USB problem?  As far as I can tell, the bug 
> > is that the system delays somewhere during the suspend procedure.  But 
> > there's no reason to think the delay is connected with USB.
> 
> Breaking news: I just got the same hang when switching from X to the
> console, so I gues that this bug has nothing to to with suspend, but
> was just triggered by the switch to the console before suspend. I guess
> I have to ask the intel-gfx folks.

Or the tty folks.

Rafael
