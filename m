Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0F3HL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:11:28 -0400
Received: from ist.d-labs.de ([213.239.218.44]:36687 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab0F3HL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:11:27 -0400
Date: Wed, 30 Jun 2010 09:10:38 +0200
From: Florian Mickler <florian@mickler.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?ISO-8859-15?B?SGr4bm5lduVn?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup
 events from being lost
Message-ID: <20100630091038.6af2a53b@schatten.dmk.lab>
In-Reply-To: <201006282101.54041.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1006281006360.1977-100000@iolanthe.rowland.org>
	<201006282101.54041.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael!

On Mon, 28 Jun 2010 21:01:53 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, June 28, 2010, Alan Stern wrote:
> > On Mon, 28 Jun 2010, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Make it possible to avoid wakeup events from being lost

I have nothing substantial to add, but just wanted to let you know that
this approach seems like a good alternative to me. As far as I can see
the userspace suspend-blocker interface could be expressed in terms of
this kernel facility which brings android closer to mainline.

The only thing I haven't thought through yet is the 'maintain a discrete
set of constraints' vs 'just increment a number' thing. Especially if
what we loose in information through that (in comparison to 'the other
approach') is made up for by easier in-kernel-API.  I _think_ if there
is any need for in-kernel-accounting (i don't know that) it could be
retro-fitted by using the trace event infrastructure?

Cheers,
Flo
