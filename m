Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab0JQVVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 17:21:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55738 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab0JQVVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 17:21:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CBB6884.7040003@s5r6.in-berlin.de>
Date: Sun, 17 Oct 2010 23:20:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <david-b@pacbell.net>, linux-usb@vger.kernel.org
Subject: Re: [Bug #20182] 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera> <7N-qxsaxKCN.A.2vB.Nk1uMB@chimera>
In-Reply-To: <7N-qxsaxKCN.A.2vB.Nk1uMB@chimera>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20182
> Subject		: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete

The bug could not be reproduced so far but might be real nonetheless.
Alan Stern proposed a fix patch:
<Pine.LNX.4.44L0.1010131011160.2311-100000@iolanthe.rowland.org>
http://lkml.org/lkml/2010/10/13/178
-- 
Stefan Richter
-=====-==-=- =-=- =---=
http://arcgraph.de/sr/
