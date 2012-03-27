Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2C0XOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 19:14:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab2C0XOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 19:14:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v5]: Hibernation: lower/better control the amount of pages used for buffering
Date: Wed, 28 Mar 2012 01:18:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <1332887486.2040.10.camel@shrek.rexursive.com> <201203280054.01695.rjw@sisk.pl> <1332888836.2040.20.camel@shrek.rexursive.com>
In-Reply-To: <1332888836.2040.20.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203280118.59154.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 28, 2012, Bojan Smojver wrote:
> On Wed, 2012-03-28 at 00:54 +0200, Rafael J. Wysocki wrote:
> > That's better, but what's wrong with a static inline, actually?
> 
> Nothing, if that is what is required to get the patch accepted. :-)
> 
> I just thought that given that nr_free_pages() is already a macro with
> no side effects, it would make sense for reqd_free_pages() or
> REQD_FREE_PAGES to remain a macro.
> 
> But, if you insist on static inline, I'll do static inline. Let me know.

Please do.  You can even convert nr_free_pages() to a static inline while
you're at it. :-)

Thanks,
Rafael
