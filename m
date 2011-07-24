Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1GXVWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 17:22:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45986 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab1GXVWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 17:22:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-2?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400
Date: Sun, 24 Jul 2011 23:23:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <201107232127.34255.toralf.foerster@gmx.de> <201107232335.35204.rjw@sisk.pl> <201107241036.20538.toralf.foerster@gmx.de>
In-Reply-To: <201107241036.20538.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107242323.54819.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 24, 2011, Toralf Förster wrote:
> 
> Rafael J. Wysocki wrote at 23:35:35
> > On Saturday, July 23, 2011, Toralf Förster wrote:
> > > Rafael J. Wysocki wrote at 21:48:44
> > > 
> > > > I wonder what happens if the machine is undocked?
> > > 
> > > No.
> > > BTW with "no_console_suspend" I got the attached kernel crash.
> > 
> > What happens if the iwlagn driver is unloaded before suspend?
> Yep - then it works fine.

Hmm.

So the failure happens only if the machine is in the dock?

Rafael
