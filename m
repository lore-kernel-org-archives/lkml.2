Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1G2VO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:14:58 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33294 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1G2VO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:14:58 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] better oopsing when frozen
Date: Fri, 29 Jul 2011 23:17:42 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <201107251043.19932.oneukum@suse.de> <201107292304.10738.oliver@neukum.org> <201107292309.44877.rjw@sisk.pl>
In-Reply-To: <201107292309.44877.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107292317.42737.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 29. Juli 2011, 23:09:44 schrieb Rafael J. Wysocki:
> On Friday, July 29, 2011, Oliver Neukum wrote:
> > Am Freitag, 29. Juli 2011, 22:27:54 schrieb Rafael J. Wysocki:
> > > However, there's another problem I didn't think of before.  Namely,
> > > we cannot thaw tasks before resuming devices in case we've already
> > > suspended them, because that will defeat the very purpose of the
> > > freezing in the first place.
> > 
> > That purpose is already defeated. The machine cannot be deader than dead.
> 
> OK, so what exactly is the purpose of the thawing, then?

We may be lucky enough to get the oops written out to disk. The oops may happen
in a driver rarely used and be late in the sequence.

	Regards
		Oliver
