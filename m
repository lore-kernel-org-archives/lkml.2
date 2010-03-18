Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0CRVgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:36:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51400 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab0CRVgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:36:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Update device power management document
Date: Thu, 18 Mar 2010 22:38:55 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1003181135200.1665-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003181135200.1665-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003182238.55618.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 March 2010, Alan Stern wrote:
> Rafael:
> 
> Here's my updated version of your patch.  It's meant as a replacement,
> rather than an additional patch.  I used much of your text but I also
> altered a lot.  And the new documentation describes the way things will
> be after Dominik Brodowski's change is added, rather than the way
> things are now.

Thanks!

I agree with all of the changes you made.

> Attribution of authorship for changes like this is difficult; the 
> existing conventions don't make allowance for patches with multiple 
> authors.  You'll have to figure out the right way to handle it.

I think I'll covert your version into a patch on top of mine for this purpose.

That's a bit artificial, but it will reflect who did what correctly, which also
is important (and the Randy's "Reviewed-by" for my patch will be preserved this
way).

Rafael
