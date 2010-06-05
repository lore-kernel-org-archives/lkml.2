Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab0FEVL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 17:11:59 -0400
Received: from ist.d-labs.de ([213.239.218.44]:42964 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702Ab0FEVL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 17:11:57 -0400
Date: Sat, 5 Jun 2010 23:11:41 +0200
From: Florian Mickler <florian@mickler.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100605231141.52de0df7@schatten.dmk.lab>
In-Reply-To: <AANLkTindQjsQRMUkxKNx-NqSiMlxUirmK2GO6zE7n0rf@mail.gmail.com>
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
	<AANLkTikna-Vs_phy2VrJs0I8gIsdSmwuxTJ67gQ_2oTt@mail.gmail.com>
	<20100605220143.08774900@schatten.dmk.lab>
	<AANLkTindQjsQRMUkxKNx-NqSiMlxUirmK2GO6zE7n0rf@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 23:26:27 +0300
Felipe Contreras <felipe.contreras@gmail.com> wrote:

> Supposing there's a perfect usage of suspend blockers from user-space
> on current x86 platforms (in theory Android would have that), is the
> benefit that big to consider this a strong argument in favor of
> suspend blockers? Considering the small amount of x86 platforms using
> Android (is there any?), the fact that nobody else will use suspend
> blockers, and that x86 is already being fixed (as mentioned many times
> before) so dynamic PM is possible, I don't think we should be
> considering current x86 at all for suspend blockers.

A solution for the desktop to deprecate having to shut down the
machine would not be that bad, wouldn;t it? (Why have I to shut down
my machine anyway?) 

In my opinion such a decision (when to shutdown) has to be guided by
userspace knowledge.
Future x86 hardware is to be fixed (as I read in this discussion), so
using suspend blockers could be the tool of choice. 

But alright. Let's be a little bit more focused on the present
situation:

1) There currently is no other solution.
2) It is a first stepping stone to bringing android to mainline.
3) Any "perfect" solution will emerge anyway. As there are so many
people with so strong opinions engaged in this discussion, I'm
confident.
4) If there is a better solution, android will shurely adapt it as
soon as it is there. 

Cheers,
Flo
