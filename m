Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab0FBJjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:39:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55468 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0FBJjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:39:19 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Florian Mickler <florian@mickler.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	 <201005302202.39511.rjw@sisk.pl>
	 <AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	 <201005312347.24251.rjw@sisk.pl>
	 <AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	 <alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	 <AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	 <alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
	 <AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 02 Jun 2010 11:39:21 +0200
Message-ID: <1275471561.27810.30865.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 01:54 -0700, Arve Hjønnevåg wrote:
> No I want you to stop confusing low power idle modes with suspend.

I think it is you who is confused. For power management purposes suspend
is nothing more but a deep idle state.

(and please don't mention @#$@ up x86 ACPI again, Intel knows, they're
fixing it, get over it already).

> Unrelated to
> Android, I also want to use opportunistic suspend on my desktop.

So you're going to sprinkle this suspend blocker shite all over regular
userspace? Why not instead work on getting apps to behave properly and
idle when there's nothing to do?

After all, if you have the code to add suspend blockers into, you also
have the means to fix it being stupid in the first place.




