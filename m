Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab0HIQGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 12:06:51 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:45873 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0HIQGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 12:06:49 -0400
Date: Mon, 9 Aug 2010 12:06:43 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@lynx
To: Jon Masters <jonathan@jonmasters.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why can't i use gdb to dump module variables anymore?
In-Reply-To: <7C33277E-D90E-4459-8580-59C5EFB2D66D@jonmasters.org>
Message-ID: <alpine.DEB.2.00.1008091200520.3863@lynx>
References: <alpine.DEB.2.00.1007080744180.7016@lynx> <7C33277E-D90E-4459-8580-59C5EFB2D66D@jonmasters.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Aug 2010, Jon Masters wrote:

>
> On Jul 8, 2010, at 7:51 AM, Robert P. J. Day wrote:
> >
> > (gdb) p rpjday_2
> > Cannot access memory at address 0xffffffffa007c0b4
> > (gdb) p rpjday_3
> > Cannot access memory at address 0xffffffffa007c0b8
>
> Did you ever get a reply to this one? Were you trying to do this
> locally, by loading a kernel core or using kgdb?

  never figured out what was happening here, used to work just fine
for simple gdb debugging of the kernel; nowadays (at least on ubuntu),
not so much.  anyway, i'm in bahstahn for linuxcon, staying at the
onyx hotel for first 3 days.  my girlfriend is doing a bofs session:

http://events.linuxfoundation.org/linuxcon2010/mckinnon

  anyway, regarding gdb, this was based on a column i wrote last
year:

http://www.linux.com/learn/linux-training/33991-the-kernel-newbie-corner-kernel-and-module-debugging-with-gdb

where it worked just fine -- it's the technique described in LDD3.
but now, on ubuntu 10.04, weirdness.  i haven't looked at it closely
again for a while, but if you have any ideas, i'm open to suggestions.
maybe some odd security/selinux/??? setting?

rday


-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
