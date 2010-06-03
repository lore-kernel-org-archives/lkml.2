Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0FCOMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:12:18 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33997 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab0FCOMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:12:17 -0400
Date: Thu, 3 Jun 2010 16:12:05 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603161205.73a2b56d@schatten.dmk.lab>
In-Reply-To: <1275550802.27810.34863.camel@twins>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<201005302202.39511.rjw@sisk.pl>
	<AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	<201005312347.24251.rjw@sisk.pl>
	<AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	<alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	<AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	<alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
	<AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
	<1275471561.27810.30865.camel@twins>
	<AANLkTilLmAb2c9fQwuguzWtjcHfuTZvPUTbUx7vuwFI6@mail.gmail.com>
	<1275474088.27810.31000.camel@twins>
	<20100602221309.6da754e7@schatten.dmk.lab>
	<1275550802.27810.34863.camel@twins>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jun 2010 09:40:02 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> Same for firefox, you can teach it to not render animated gifs and run
> javascript for invisible tabs, and once the screen-saver kicks in,
> nothing is visible (and with X telling apps their window is visible or
> not it knows), so it should go idle all of its own.
> 
> Fix the friggin apps, don't kludge with freezing.

Of course programs should be as smart as possible. But that is an
orthogonal problem.

Suppose firefox were fixed. It still needs to fetch my rss feeds every
minute, because I'm sad if it doesn't. It just can't be fixed at the
application level.

Cheers,
Flo
