Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab0FUQBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:01:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40820 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757152Ab0FUQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:01:10 -0400
Date: Mon, 21 Jun 2010 12:01:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: markgross@thegnar.org
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <20100621061345.GF9735@gvim.org>
Message-ID: <Pine.LNX.4.44L0.1006211158200.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010, mark gross wrote:

> Your confused about what problem this patch attempts to solve.

I don't think so.  Rafael's description was pretty clear.

>  There is
> a pm_qos patch in the works to address the suspend blocker
> functionality.
> http://lists.linux-foundation.org/pipermail/linux-pm/2010-June/026760.html

No.  That patch addresses something _similar_ to the suspend blocker
functionality.  The fact remains, though, that pm_qos is not used
during system suspend (the /sys/power/state interface), hence changes
to pm_qos won't solve the system-suspend problems that suspend blockers 
do solve.

Alan Stern

