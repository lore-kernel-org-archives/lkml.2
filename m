Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0JQVaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 17:30:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab0JQVaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 17:30:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug #20182] 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
Date: Sun, 17 Oct 2010 23:29:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <david-b@pacbell.net>, linux-usb@vger.kernel.org
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera> <7N-qxsaxKCN.A.2vB.Nk1uMB@chimera> <4CBB6884.7040003@s5r6.in-berlin.de>
In-Reply-To: <4CBB6884.7040003@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010172329.02356.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 17, 2010, Stefan Richter wrote:
> Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20182
> > Subject		: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
> 
> The bug could not be reproduced so far but might be real nonetheless.
> Alan Stern proposed a fix patch:
> <Pine.LNX.4.44L0.1010131011160.2311-100000@iolanthe.rowland.org>
> http://lkml.org/lkml/2010/10/13/178

Thanks, I've updated the bug with the patch information.

Rafael
