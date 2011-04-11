Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1DKSif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:38:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57027 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755393Ab1DKSid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:38:33 -0400
Date: Mon, 11 Apr 2011 14:38:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-bluetooth@vger.kernel.org>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
In-Reply-To: <BANLkTikNb7FEDMbX3wSMti2e3muiaLZh-g@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104111437440.1975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, Zdenek Kabelac wrote:

> > I've created:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=33062
> >
> > and I'm cc-ing linux-bluetooth.
> >
> 
> In fact this Ooops might be related to:
> 
> http://marc.info/?l=linux-kernel&m=130207593728273&w=2

It might be.  Did you try reverting the patch mentioned in that email?

Alan Stern

