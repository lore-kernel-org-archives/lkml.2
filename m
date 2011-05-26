Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1EZMZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:25:21 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:1994 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757288Ab1EZMZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:25:20 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p4QCOxq2020137
Subject: Re: UNIX Compatibility
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Valdis.Kletnieks@vt.edu
Cc: Michael Witten <mfwitten@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Mike Galbraith <efault@gmx.de>, Richard Yao <ryao@ic.sunysb.edu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <38084.1306411679@localhost>
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>
	 <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
	 <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
	 <20110524181619.GC26055@thunk.org>
	 <BANLkTi=QUS5WfAMWTw7vuEwuBOVHsww3mA@mail.gmail.com>
	 <1306297108.4819.28.camel@marge.simson.net>
	 <64e4614dda6f4558a68a314d7b5979b5-mfwitten@gmail.com>
	 <20110525143602.GE8476@thunk.org>
	 <c943132c8c364f95a91e3cf81cb0f2bd-mfwitten@gmail.com>
	 <1306409439.28597.81.camel@thorin>  <38084.1306411679@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 14:24:59 +0200
Message-ID: <1306412699.28597.90.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Don, 2011-05-26 at 08:07 -0400, Valdis.Kletnieks@vt.edu wrote: 
> On Thu, 26 May 2011 13:30:39 +0200, Bernd Petrovitsch said:
> 
> > Or take the "unlink a directory gives EPERM" example: why is it
> > specified with an errno that indicates that the user is not allowed to
> > remove it (and not that the sys-call is the wrong one).
> 
> Because on some old Unix's, it wasn't the wrong syscall...

Oh well, I'm probably too young for that ....

> RATIONALE
> 
> Unlinking a directory is restricted to the superuser in many historical
> implementations for reasons given in link() (see also rename()).
> 
> http://pubs.opengroup.org/onlinepubs/009695399/functions/unlink.html

So someone changes the semantics of the unlink() sys-call (obviously in
some compatible, standards-compliant way) as it no longer unlinks
directories but it is not possible to define the returned errno for
the new error case to something sane?

What did I miss?

Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

