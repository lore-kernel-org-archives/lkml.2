Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331Ab2C3TdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:33:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760501Ab2C3TdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:33:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v7]: Hibernation: lower/better control the amount of pages used for buffering
Date: Fri, 30 Mar 2012 21:37:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <1332891672.2040.24.camel@shrek.rexursive.com> <201203282329.11086.rjw@sisk.pl> <1333071789.2058.2.camel@shrek.rexursive.com>
In-Reply-To: <1333071789.2058.2.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203302137.37731.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 30, 2012, Bojan Smojver wrote:
> On Wed, 2012-03-28 at 23:29 +0200, Rafael J. Wysocki wrote:
> > OK, I'll take this one for v3.5.
> 
> BTW, I thought that 3.4 merge window was still open. No?

It is, but I have prepared my material for merging already and the patch
was too late.  Sorry about that.

Still, if it is a regression fix, I can push it even after -rc1 is out,
so no worries in that case.

Thanks,
Rafael
