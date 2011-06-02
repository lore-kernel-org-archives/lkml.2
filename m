Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1FNGsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:48:10 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47177 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753489Ab1FNGsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:48:05 -0400
Date: Fri, 3 Jun 2011 00:21:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] pm loss development
Message-ID: <20110602222111.GA15414@ucw.cz>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
 <201105180107.58078.rjw@sisk.pl>
 <20110518031203.GA3640@gvim.org>
 <201105182143.13237.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105182143.13237.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > What do you mean by safe state?
> > >
> > I need to get more details on this but I assume its a state where the
> > meta data of the file system is committed to the emmc before lights go
> > off such that when power is reapplied that the damage isn't too big. 
> 
> I don't think you can guarantee that the metadata won't be damaged
> without notifying the filesystem of the event (and making it react
> appropriately).

Journalling filesystem should survive power loss at random time, as
long as block device behaves like a disk (i.e. writes whole sectors).

And that can be guaranteed at driver level...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
