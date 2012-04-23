Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab2DWVyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:54:36 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60732 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827Ab2DWVyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:54:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Mon, 23 Apr 2012 23:59:13 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <1335133792.2187.8.camel@shrek.rexursive.com> <1335216712.2187.17.camel@shrek.rexursive.com>
In-Reply-To: <1335216712.2187.17.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204232359.14109.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 23, 2012, Bojan Smojver wrote:
> On Mon, 2012-04-23 at 08:29 +1000, Bojan Smojver wrote:
> > Hibernation regression fix, since 3.2
> 
> Rafael,
> 
> Any chance of queuing up this simpler patch for stable? We don't want
> people's computers to hang on hibernation when there is a fix, right?

OK

Please resend it with a better changelog.  I mean, please explain what
the regression is and why it is being fixed this way.

Thanks,
Rafael
