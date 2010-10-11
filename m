Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab0JKWJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:09:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36329 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513Ab0JKWJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:09:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH v7] power: introduce library for device-specific OPPs
Date: Tue, 12 Oct 2010 00:08:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-pm" <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "l-o" <linux-omap@vger.kernel.org>,
        "l-a" <linux-arm-kernel@lists.infradead.org>,
        Paul <paulmck@linux.vnet.ibm.com>
References: <[PATCH] power: introduce library for device-specific OPPs> <201010100059.20964.rjw@sisk.pl> <4CB32675.1090205@ti.com>
In-Reply-To: <4CB32675.1090205@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010120008.16388.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 11, 2010, Nishanth Menon wrote:
> Rafael J. Wysocki had written, on 10/09/2010 05:59 PM, the following:
> [...]
> >>
> >> Signed-off-by: Nishanth Menon <nm@ti.com>
> > 
> > OK
> > 
> > Your error messages are a bit inconsistent (e.g. some of them print the
> > error code while others don't), but I guess I can fix that up.
> Thanks a bunch.
> > 
> > Still, to apply the patch I need a copyright notice for the doc too.
> oops..
> (C) 2009-2010 Nishanth Menon <nm@ti.com>, Texas Instruments Incorporated
> Does this help?

Yes, it does.

> or would you like me to post a v8 as well?

That shouldn't be necessary.

Thanks,
Rafael
