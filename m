Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab2DVL6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 07:58:55 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab2DVL6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 07:58:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Per Olofsson <pelle@debian.org>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Sun, 22 Apr 2012 14:03:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204221347.52883.rjw@sisk.pl> <4F93F0B9.3070101@debian.org>
In-Reply-To: <4F93F0B9.3070101@debian.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204221403.32758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 22, 2012, Per Olofsson wrote:
> 2012-04-22 13:47, Rafael J. Wysocki skrev:
> >> > Any chance of it in 3.3.3?
> > Nope.
> > 
> >> > Looks like rc1 of it is already out there...
> > I'm going to push it for v3.5, so it will only appear in 3.4.y I guess.
> 
> What about 3.2.y?

That depends on Greg.  If 3.2.y is still being continued when 3.5 is out, I think
it also will appear in there.  I'll just add the "CC stable" tag to the commit.

Thanks,
Rafael
