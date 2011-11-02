Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1KBXOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:14:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47020 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1KBXO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:14:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 3/3] ARM: mach-shmobile: sh7372 A4R support (v4)
Date: Thu, 3 Nov 2011 00:17:00 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <201110200012.43840.rjw@sisk.pl> <Pine.LNX.4.64.1111021132240.19054@axis700.grange> <CANqRtoS5KTws7rDoHkxrq8DP+js5xq=YF3zQG4MYmmjHEtv5NA@mail.gmail.com>
In-Reply-To: <CANqRtoS5KTws7rDoHkxrq8DP+js5xq=YF3zQG4MYmmjHEtv5NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111030017.00780.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 02, 2011, Magnus Damm wrote:
> On Wed, Nov 2, 2011 at 11:38 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Thu, 20 Oct 2011, Rafael J. Wysocki wrote:
> >
> >> From: Magnus Damm <damm@opensource.se>
> >>
> >> This change adds support for the sh7372 A4R power domain.
> >
> > This version still breaks I2C (#0) on mackerel. Tested with your
> > sh7372-test branch of Oct 18th plus these four patches:
> >
> > 6b29305a PM / Domains: Add default power off governor function (v2)
> > 3d578ae PM / Domains: Add device stop governor function (v2)
> > 6c2cd02 ARM: mach-shmobile: sh7372 A4R support (v4)
> > 9da11f4 ARM: mach-shmobile: sh7372 A3SP support (v4)
> 
> Exactly how does it break IIC0?

It causes some initialization issues to happen.  I get the following
messages on every boot:

i2c-sh_mobile i2c-sh_mobile.0: Transfer request timed out
i2c-sh_mobile i2c-sh_mobile.0: Polling timed out

three times in a row (there's a delay too).

The A4R patch is the source of that.

> Does the same happen with the code base for upcoming 3.2-rc1 from
> latest linux git?

Yes, it does, AFAICT.

Thanks,
Rafael
