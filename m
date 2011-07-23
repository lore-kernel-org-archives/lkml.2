Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab1GWVei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 17:34:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45122 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab1GWVef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 17:34:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-2?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400
Date: Sat, 23 Jul 2011 23:35:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <201107232127.34255.toralf.foerster@gmx.de> <201107232148.44702.rjw@sisk.pl> <201107232227.37429.toralf.foerster@gmx.de>
In-Reply-To: <201107232227.37429.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107232335.35204.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 23, 2011, Toralf Förster wrote:
> 
> Rafael J. Wysocki wrote at 21:48:44
> > 
> > I wonder what happens if the machine is undocked?
> No.
> BTW with "no_console_suspend" I got the attached kernel crash.

What happens if the iwlagn driver is unloaded before suspend?

Rafael
