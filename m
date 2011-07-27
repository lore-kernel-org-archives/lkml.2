Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1G0VzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:55:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56815 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724Ab1G0VzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:55:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2] MMC / TMIO: Fix build issue related to struct scatterlist
Date: Wed, 27 Jul 2011 23:56:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
References: <201107262049.15333.rjw@sisk.pl> <201107262050.23379.rjw@sisk.pl> <Pine.LNX.4.64.1107272236510.7435@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1107272236510.7435@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107272356.16817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 27, 2011, Guennadi Liakhovetski wrote:
> (added MMC maintainer to CC:)
> 
> On Tue, 26 Jul 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Fix build issue caused by undefined struct scatterlist in
> > drivers/mmc/host/tmio_mmc.c.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> A nitpick, if I may: sCatterlist comes before sPinlock in my versions of 
> most popular alphabets;-) Please, fix (or maybe Chris can fix it himself), 

I'm not sure what you mean exactly (perhaps it's too late).

Rafael
