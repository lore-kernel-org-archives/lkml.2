Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0JMU3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:29:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab0JMU3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:29:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 13/23] Hibernation: Partial page I/O support.
Date: Wed, 13 Oct 2010 22:28:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <1285566238-10966-14-git-send-email-nigel@tuxonice.net> <20101013071008.GA1610@ucw.cz>
In-Reply-To: <20101013071008.GA1610@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010132228.22604.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 13, 2010, Pavel Machek wrote:
> Hi!
> 
> > Add functions that can be used for coalescing and splitting buffers
> > that are smaller than PAGE_SIZE. These functions provide no method
> > of determining where the boundaries of the smaller buffers are to
> > be found - that is the caller's problem.
> 
> I don't get it; why do we need that support?

This is related to compression.  This way we can put data from two or more
compressed pages into one page frame.

Thanks,
Rafael
