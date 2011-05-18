Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1ERWRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:17:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37540 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1ERWRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:17:33 -0400
Date: Wed, 18 May 2011 23:17:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] pm loss development
Message-ID: <20110518221726.GC20909@sirena.org.uk>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <201105180107.58078.rjw@sisk.pl> <20110518031203.GA3640@gvim.org> <201105182143.13237.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105182143.13237.rjw@sisk.pl>
X-Cookie: Forgive and forget.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 09:43:13PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, May 18, 2011, mark gross wrote:

> > I need to get more details on this but I assume its a state where the
> > meta data of the file system is committed to the emmc before lights go
> > off such that when power is reapplied that the damage isn't too big. 

> I don't think you can guarantee that the metadata won't be damaged
> without notifying the filesystem of the event (and making it react
> appropriately).

I guess with a journalling filesystem you'd hope that you can at any
point write out what's in flight and have it be safe; if it's a non
journalling filesystem of course all bets are off.
