Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab0EYATo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 20:19:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895Ab0EYATn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 20:19:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [Regression] Commit "power_supply: Use attribute groups" breaks KDE battery monitor on openSUSE 11.3 M6
Date: Tue, 25 May 2010 02:20:45 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201005250028.24687.rjw@sisk.pl> <20100524223221.GQ30801@buzzloop.caiaq.de> <201005250103.09009.rjw@sisk.pl>
In-Reply-To: <201005250103.09009.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005250220.45889.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Rafael J. Wysocki wrote:
> On Tuesday 25 May 2010, Daniel Mack wrote:
> > On Tue, May 25, 2010 at 12:28:24AM +0200, Rafael J. Wysocki wrote:
> > > Your commit 5f487cd34f4337f9bc27ca19da72a39d1b0a0ab4 (power_supply: Use
> > > attribute groups) unfortunately breaks KDE 4.4's battery monitor from openSUSE
> > > 11.3 Milestone 6 on my Acer Ferrari One.  Apparently, the battery monitor can't
> > > access the sysfs battery attributes with this commit applied.
> > 
> > Can you still see the attributes in sysfs?
> 
> Yes, I can.

Ah, sorry.  The 'type' property is not present (I didn't notice that before).

Rafael
