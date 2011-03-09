Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1CIUZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 15:25:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1CIUZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 15:25:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wang Lei <f3d27b@gmail.com>
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
Date: Wed, 9 Mar 2011 21:25:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com> <201103091141.28396.rjw@sisk.pl> <4d77806c.0bf98e0a.28c5.7cc5@mx.google.com>
In-Reply-To: <4d77806c.0bf98e0a.28c5.7cc5@mx.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103092125.43950.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 09, 2011, Wang Lei wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> >
> > There was only one commit in that area since 2.6.38-rc6, but it shouldn't
> > affect the functionality this way.
> >
> > Is yout thermal management controlled by ACPI?
> >
> > Rafael
> 
> Thanks for your reply!
> 
> How could I know that?

What does "ls -l /sys/class/thermal/cooling_device0/device" say?

Rafael
