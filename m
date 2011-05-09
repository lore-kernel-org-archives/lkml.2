Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1EITV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:21:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34343 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab1EITV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:21:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Todd Poynor <toddpoynor@google.com>
Subject: Re: [linux-pm] [PATCH 1/5] PM / Runtime: Support for generic I/O power domains (v3)
Date: Mon, 9 May 2011 21:22:09 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <201104290154.12966.rjw@sisk.pl> <201105082322.44268.rjw@sisk.pl> <BANLkTinPGQNUrFnyFVazqA72iyMbB-K_OA@mail.gmail.com>
In-Reply-To: <BANLkTinPGQNUrFnyFVazqA72iyMbB-K_OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105092122.09690.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 09, 2011, Todd Poynor wrote:
> On Sun, May 8, 2011 at 2:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> ...
> 
> > power management (i.e. ->stop_device() may disable a device's
> > clocks, while ->start_device() may enable them, ->power_on() is
> > supposed to remove power from the entire power domain
> > and ->power_off() is supposed to restore it).
> >
> 
> power_off removes power, power_on restores?

Yes, that's the intention.  Thanks for spotting that!

Rafael
