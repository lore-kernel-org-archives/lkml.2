Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab1DLSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:25:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39940 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab1DLSZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:25:54 -0400
Date: Tue, 12 Apr 2011 15:26:18 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-bluetooth@vger.kernel.org
Subject: Re: Endless print of uhci_result_common: failed with status 440000
Message-ID: <20110412182618.GB2836@joana>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-bluetooth@vger.kernel.org
References: <BANLkTin0bKs1D3JxVODw3F+qH0ZqRwh5KA@mail.gmail.com>
 <Pine.LNX.4.44L0.1104121210250.2000-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104121210250.2000-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Stern <stern@rowland.harvard.edu> [2011-04-12 12:10:56 -0400]:

> On Tue, 12 Apr 2011, Zdenek Kabelac wrote:
> 
> > 2011/4/11 Alan Stern <stern@rowland.harvard.edu>:
> > > On Mon, 11 Apr 2011, Zdenek Kabelac wrote:
> > >
> > >> > I've created:
> > >> >
> > >> > https://bugzilla.kernel.org/show_bug.cgi?id=33062
> > >> >
> > >> > and I'm cc-ing linux-bluetooth.
> > >> >
> > >>
> > >> In fact this Ooops might be related to:
> > >>
> > >> http://marc.info/?l=linux-kernel&m=130207593728273&w=2
> > >
> > > It might be. ?Did you try reverting the patch mentioned in that email?
> > >
> > 
> > Yep - it looks like the patch
> > http://marc.info/?l=linux-bluetooth&m=130230770920378&w=2
> > solved my problem with weird deadlocks.

I pushed a patch that fixes this in a better way, it's on the bluetooth-2.6
tree (should arrive to linus tree in some days).

-- 
Gustavo F. Padovan
http://profusion.mobi
