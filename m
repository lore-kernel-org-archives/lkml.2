Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab1G2V5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:57:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34860 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1G2V5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:57:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] better oopsing when frozen
Date: Fri, 29 Jul 2011 23:30:09 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <201107251043.19932.oneukum@suse.de> <201107292309.44877.rjw@sisk.pl> <201107292317.42737.oliver@neukum.org>
In-Reply-To: <201107292317.42737.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107292330.09797.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 29, 2011, Oliver Neukum wrote:
> Am Freitag, 29. Juli 2011, 23:09:44 schrieb Rafael J. Wysocki:
> > On Friday, July 29, 2011, Oliver Neukum wrote:
> > > Am Freitag, 29. Juli 2011, 22:27:54 schrieb Rafael J. Wysocki:
> > > > However, there's another problem I didn't think of before.  Namely,
> > > > we cannot thaw tasks before resuming devices in case we've already
> > > > suspended them, because that will defeat the very purpose of the
> > > > freezing in the first place.
> > > 
> > > That purpose is already defeated. The machine cannot be deader than dead.
> > 
> > OK, so what exactly is the purpose of the thawing, then?
> 
> We may be lucky enough to get the oops written out to disk. The oops may happen
> in a driver rarely used and be late in the sequence.

OK, so is there any guarantee that we won't corrupt things this way?

Rafael
