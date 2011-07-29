Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1G2VIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:08:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34763 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1G2VIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:08:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] better oopsing when frozen
Date: Fri, 29 Jul 2011 23:09:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <201107251043.19932.oneukum@suse.de> <201107292227.54948.rjw@sisk.pl> <201107292304.10738.oliver@neukum.org>
In-Reply-To: <201107292304.10738.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107292309.44877.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 29, 2011, Oliver Neukum wrote:
> Am Freitag, 29. Juli 2011, 22:27:54 schrieb Rafael J. Wysocki:
> > However, there's another problem I didn't think of before.  Namely,
> > we cannot thaw tasks before resuming devices in case we've already
> > suspended them, because that will defeat the very purpose of the
> > freezing in the first place.
> 
> That purpose is already defeated. The machine cannot be deader than dead.

OK, so what exactly is the purpose of the thawing, then?

Rafael
