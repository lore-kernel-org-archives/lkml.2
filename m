Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab0HTXZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 19:25:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab0HTXZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 19:25:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.36-rc1: Doesn't boot on an AMD-based machine
Date: Sat, 21 Aug 2010 01:23:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
References: <201008172206.14349.rjw@sisk.pl> <4C6EB823.1070300@zytor.com> <AANLkTikwPXL+i0MJSMu5Hw1KLrG=G+BZoatE4QEsngnT@mail.gmail.com>
In-Reply-To: <AANLkTikwPXL+i0MJSMu5Hw1KLrG=G+BZoatE4QEsngnT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008210123.26858.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 20, 2010, Linus Torvalds wrote:
> On Fri, Aug 20, 2010 at 10:15 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > I have a fix from Hans queued up in x86/urgent and it will be in the
> > next push of the fixes queue, which I am planning to send you today.
> >
> > http://git.kernel.org/tip/07a7795ca2e6e66d00b184efb46bd0e23d90d3fe
> 
> Rafael, can you confirm that that fixes it?

Yes, it does (sorry for being late).

Rafael
