Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1G3RNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 13:13:53 -0400
Received: from lunge.queued.net ([173.255.254.236]:51812 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1G3RNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 13:13:47 -0400
Date: Sat, 30 Jul 2011 10:13:44 -0700
From: Andres Salomon <dilinger@queued.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>, Daniel Drake <dsd@laptop.org>,
        cjb@laptop.org, linux-kernel@vger.kernel.org,
        libertas-dev@lists.infradead.org
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
Message-ID: <20110730101344.645e22dc@debxo>
In-Reply-To: <1311977825.20983.15.camel@i7.infradead.org>
References: <20110618213803.521db1b3@debxo>
	<20110618214203.0028ba85@debxo>
	<BANLkTimyFj+iTWAopPMEyohP2pop_=g=6g@mail.gmail.com>
	<1308631634.31157.7.camel@dcbw.foobar.com>
	<20110621001805.1caecc82@queued.net>
	<1311977825.20983.15.camel@i7.infradead.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 23:17:03 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2011-06-21 at 00:18 -0700, Andres Salomon wrote:
> > Looks like the one on dev.l.o is older (9.70.7.p0).  Shall I redo
> > the pull request a) ignoring sd8686, b) replacing usb8388 v5 with
> > the OLPC version, and c) including both thinfirm blobs as well,
> > then? 
> 
> Is there a conclusion on what I should be pulling in?
> 

Sorry for the delay, I'll put together a pull request for you today.
