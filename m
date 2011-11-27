Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1K0LnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:43:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58520 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab1K0LnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:43:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage metering applications has gone crackers
Date: Sun, 27 Nov 2011 12:45:57 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Artem S. Tashkinov" <t.artem@lycos.com>
References: <1718181782.740375.1322130615898.JavaMail.mail@webmail19> <20111124200553.GA13353@mac.home> <20111127110400.GA4672@mac.home>
In-Reply-To: <20111127110400.GA4672@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111271245.57772.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 27, 2011, Tino Keitel wrote:
> On Thu, Nov 24, 2011 at 21:05:53 +0100, Tino Keitel wrote:
> > On Thu, Nov 24, 2011 at 10:30:15 +0000, Artem S. Tashkinov wrote:
> > > Hello,
> > > 
> > > I'd like to report a weird regression in Linux 3.2 (running rc3 now) - all CPU metering applications have gone terribly mad
> > > under this kernel:
> > 
> > I get the same using top, htop and the gnome system monitor with kernel
> > 3.2 on a Sandy Bridge quad core box, running Debian unstable.
> 
> I just tested 3.2-rc2, and see the same bug.

I'm seeing that too on one of my test boxes, but not all the time
(i.e. there are periods in which the readings are correct).  The other boxes
I've tested with 3.2-rc are fine in that respect.

Also, it seems that it shows 100%-(real load) when it is wrong.  So, it looks
like there's an overflow somewhere in the CPU load measuring code, at least
on some CPUs.

What's your CPU, BTW?

Thanks,
Rafael
