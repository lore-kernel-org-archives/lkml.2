Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0G3Cul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 22:50:41 -0400
Received: from thunk.org ([69.25.196.29]:32956 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab0G3Cuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 22:50:40 -0400
Date: Thu, 29 Jul 2010 22:50:38 -0400
Message-Id: <E1OefgE-0005vu-JN@tytso-glaptop>
To: linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: PSA: Please update your flash plugin!
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a public service announcement --- if you are running Flash 10.0,
make sure you upgrade to 10.1.  Flash 10.0 has a horrible security
vulnerability:

	http://www.adobe.com/support/security/bulletins/apsb10-14.html

I have Google Analytics running on the ksummit2010 website, and in
addition to discovering that 59% used Firefox and 25% were using Chrome,
and that the most popular screen resolution was 1280x800 followed by
1280x1024, etc. --- I also was able to find that while 59% were running
Flash 10.1, over 40% of the visitors to the ksummit2010 web site were
running a vulnerable version of Adobe flash, which has a remote code
execution vulerability.

If you were visiting that site from your development system, which you
use to push changes to a subsystem maintianer, or even Linus, hopefully
I don't need to tell you what a bad idea it is to leave yourself open
and vulnerable like this.  (This particular security problem with Flash
has been announced for almost 2 months at this point!)

						- Ted
