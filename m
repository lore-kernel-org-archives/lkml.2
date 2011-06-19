Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1FSNqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 09:46:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39658 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1FSNqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 09:46:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/2] PM: fix async resume following suspend failure
Date: Sun, 19 Jun 2011 15:47:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1106182134290.3523-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106182134290.3523-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191547.15512.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 19, 2011, Alan Stern wrote:
> On Sat, 18 Jun 2011, Rafael J. Wysocki wrote:
> 
> > > Okay; I should have been more careful.  Thanks for fixing this up.
> > 
> > No problem. :-)
> > 
> > Appended is what I'm going to push to Linus.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> > From: Alan Stern <stern@rowland.harvard.edu>
> > Subject: PM: Fix async resume following suspend failure
> 
> This looks fine.  It's a little hard to test; you have to create an 
> artificial suspend failure.  Have you tried doing that?

Not yet, but I have a plan to do that. :-)

Thanks,
Rafael
