Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab2DOWEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 18:04:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44358 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab2DOWEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 18:04:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Per Olofsson <pelle@debian.org>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Mon, 16 Apr 2012 00:08:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org
References: <1334267969.2573.14.camel@shrek.rexursive.com> <4F8AC34F.1050702@debian.org>
In-Reply-To: <4F8AC34F.1050702@debian.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204160008.41104.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 15, 2012, Per Olofsson wrote:
> 2012-04-12 23:59, Bojan Smojver skrev:
> > Hi Rafael,
> > 
> > Yes, I know - it is getting a bit ridiculous. Such a simple problem, so
> > many patches. Anyhow...
> > 
> > Here we also fix the calculation of pages for read buffering. Not really
> > very significant, but may become important in some really tight memory
> > scenarios. And after thinking more about low_free_pages() inline
> > function, Per was right - it is better to call an already existing
> > function, rather than roll our own. Keeps kernel smaller and there is no
> > significant performance gain otherwise.
> > 
> > Per,
> > 
> > Feel free to reply with your signed-off.
> 
> Signed-off-by: Per Olofsson <pelle@debian.org>

Why signed-off?

Rafael
