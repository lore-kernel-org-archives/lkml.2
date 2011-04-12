Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab1DLQK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:10:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46612 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758056Ab1DLQK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:10:57 -0400
Date: Tue, 12 Apr 2011 12:10:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-bluetooth@vger.kernel.org>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
In-Reply-To: <BANLkTin0bKs1D3JxVODw3F+qH0ZqRwh5KA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104121210250.2000-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Zdenek Kabelac wrote:

> 2011/4/11 Alan Stern <stern@rowland.harvard.edu>:
> > On Mon, 11 Apr 2011, Zdenek Kabelac wrote:
> >
> >> > I've created:
> >> >
> >> > https://bugzilla.kernel.org/show_bug.cgi?id=33062
> >> >
> >> > and I'm cc-ing linux-bluetooth.
> >> >
> >>
> >> In fact this Ooops might be related to:
> >>
> >> http://marc.info/?l=linux-kernel&m=130207593728273&w=2
> >
> > It might be.  Did you try reverting the patch mentioned in that email?
> >
> 
> Yep - it looks like the patch
> http://marc.info/?l=linux-bluetooth&m=130230770920378&w=2
> solved my problem with weird deadlocks.

Okay, great!

Alan Stern

