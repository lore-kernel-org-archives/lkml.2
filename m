Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1CJAGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:06:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1CJAGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:06:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wang Lei <f3d27b@gmail.com>
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
Date: Thu, 10 Mar 2011 01:06:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com> <201103092125.43950.rjw@sisk.pl> <4d780a2f.231a8f0a.3b01.ffffa228@mx.google.com>
In-Reply-To: <4d780a2f.231a8f0a.3b01.ffffa228@mx.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103100106.36678.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 10, 2011, Wang Lei wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Wednesday, March 09, 2011, Wang Lei wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >> >
> >> > There was only one commit in that area since 2.6.38-rc6, but it shouldn't
> >> > affect the functionality this way.
> >> >
> >> > Is yout thermal management controlled by ACPI?
> >> >
> >> > Rafael
> >> 
> >> Thanks for your reply!
> >> 
> >> How could I know that?
> >
> > What does "ls -l /sys/class/thermal/cooling_device0/device" say?
> >
> > Rafael
> 
> [~]$ ls -l /sys/class/thermal/cooling_device0/device
> lrwxrwxrwx 1 root root 0 Mar 10 07:13 /sys/class/thermal/cooling_device0/device -> ../../../LNXSYSTM:00/device:47/PNP0C0B:00
> [~]$

That's ACPI.

I don't know, however, which change might cause the problem to happen.

Can you bisect the commits between 2.6.38-rc6 and -rc7 to find the one that
introduced the issue?

Rafael
