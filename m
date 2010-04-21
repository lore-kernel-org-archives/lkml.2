Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0DUFOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:14:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53928 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab0DUFOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:14:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: 2.6.34-rc5: Reported regressions from 2.6.33
Date: Wed, 21 Apr 2010 07:15:38 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <20100420135636.GA10674@elliptictech.com>
In-Reply-To: <20100420135636.GA10674@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004210715.38621.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 April 2010, Nick Bowler wrote:
> On 05:15 Tue 20 Apr     , Rafael J. Wysocki wrote:
> > If you know of any other unresolved regressions from 2.6.33, please let us
> > know either and we'll add them to the list.  Also, please let us know
> > if any of the entries below are invalid.
> 
> Please list these two similar regressions from 2.6.33 in the r600 DRM:
> 
>  * r600 CS checker rejects GL_DEPTH_TEST w/o depth buffer:
>            https://bugs.freedesktop.org/show_bug.cgi?id=27571
> 
>  * r600 CS checker rejects narrow FBO renderbuffers:
>            https://bugs.freedesktop.org/show_bug.cgi?id=27609

Do you want to me to add them as one entry or as two separate bugs?

Rafael
