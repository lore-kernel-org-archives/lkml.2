Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab1EZLsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:48:17 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:6240 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757245Ab1EZLsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:48:03 -0400
X-Greylist: delayed 1035 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 07:48:00 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p4QBUdHw019606
Subject: Re: UNIX Compatibility
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Michael Witten <mfwitten@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Mike Galbraith <efault@gmx.de>,
        Richard Yao <ryao@ic.sunysb.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <c943132c8c364f95a91e3cf81cb0f2bd-mfwitten@gmail.com>
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>
	 <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
	 <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
	 <20110524181619.GC26055@thunk.org>
	 <BANLkTi=QUS5WfAMWTw7vuEwuBOVHsww3mA@mail.gmail.com>
	 <1306297108.4819.28.camel@marge.simson.net>
	 <64e4614dda6f4558a68a314d7b5979b5-mfwitten@gmail.com>
	 <20110525143602.GE8476@thunk.org>
	 <c943132c8c364f95a91e3cf81cb0f2bd-mfwitten@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 13:30:39 +0200
Message-ID: <1306409439.28597.81.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2011-05-25 at 15:17 +0000, Michael Witten wrote:
[...] 
> What needs to die is the tyranny of the hackers.

The problem with that is, that it is replaced with a tyranny of some
others like marketing folks, sales droids or paper pushers - which is
even worse, especially if the "decision" is a compromise.

Think about why there are so many "bad" standards. Mainly because most
of them (if not all) are a compromise to fit to already existing
implementations of competing vendors ....

Or take the "unlink a directory gives EPERM" example: why is it
specified with an errno that indicates that the user is not allowed to
remove it (and not that the sys-call is the wrong one).

> Humans are capable of organizing themselves better than just acquiscing to
> whomever is capable of imposing himself fastest.

If it's with (self written) good patches, it's a good thing. Imposing
with a (not necessarily self-written) presentation at a meeting is
something completely different ....

Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at



