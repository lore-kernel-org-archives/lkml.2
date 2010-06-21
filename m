Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab0FUSoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:44:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab0FUSoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:44:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: chris2553@googlemail.com
Subject: Re: [Bug #16231] Noticeable slow-down in 2.6.35-rc3
Date: Mon, 21 Jun 2010 20:42:44 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "John Fastabend" <john.r.fastabend@intel.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera> <W8JfMs9cZw.A.xkE.aMpHMB@chimera> <201006210658.08740.chris2553@googlemail.com>
In-Reply-To: <201006210658.08740.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006212042.44286.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 21, 2010, Chris Clayton wrote:
> On Sunday 20 June 2010, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the
> > tracking team know (either way).
> >
> 
> As noted below, the problem is fixed by John's patch. I added a Tested-by to the 
> bugzilla report a few days ago. I guess it should stay open, however, until 
> Linus has applied the patch to mainline.

Thanks for the update.

Rafael
