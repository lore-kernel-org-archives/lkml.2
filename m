Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1AGUvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:51:10 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41668 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab1AGUvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=C+4kQsMTGpVEkyAsSHzJHLmcOhGklq25sBouzOdOtlT+yOKJ6Z+PXw7czOyqIjapxv
         ZOHAQiBsY/fylJMQJ4Gx7d4Iy9CHk2UyBjh8XIxPj3ljJVNW8/8iRSZALQIpMTxdRyXx
         VUsooqir/rzfhHakQjLS3Yv0+cQpK8mDJwxHY=
MIME-Version: 1.0
Date: Fri, 7 Jan 2011 14:51:08 -0600
Message-ID: <AANLkTimJ+g=VuvW0HeGKX1my4JY+nWkBbRhP9nCFeawd@mail.gmail.com>
Subject: Any hardware timers avialable to user-space?
From: Paul Sheer <paulsheer@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I'm looking for a way to return the value of any hardware clock to user-space:

Dan Bernstein's 'clockspeed' (http://cr.yp.to/clockspeed.html) package
relies on the Pentium RDTSC instruction on Linux or gethrtime() on Solaris.
On Solaris, gethrtime() is the same as clock_gettime(CLOCK_MONOTONIC,...)

On Linux clock_gettime(CLOCK_MONOTONIC,...) incurs adjustments
(so sayeth lkml archives) and doesn't seem suitable for implementing
the kind of "ntp" client that is clockspeed's purpose.

Mentioned in Documentation/kvm/timekeeping.txt are a number of PC
hardware clocks like the 82C54.

Are any of these available to user space?

Are there any plans to create a gethrtime() function like on Solaris?

Has anyone suggested a new clock_gettime(CLOCK_HARDWARE,...) system call?

Many thanks

-paul
