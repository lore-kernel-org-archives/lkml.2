Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0E2JEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 05:04:35 -0400
Received: from ist.d-labs.de ([213.239.218.44]:56493 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0E2JEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 05:04:34 -0400
Date: Sat, 29 May 2010 11:04:26 +0200
From: Florian Mickler <florian@mickler.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100529110426.077cba47@schatten.dmk.lab>
In-Reply-To: <201005290011.32543.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
	<AANLkTimqvMuMpB5E3tj58OtlRc-7mVaec-9EHAegywg7@mail.gmail.com>
	<1275032623.32462.30.camel@laptop>
	<201005290011.32543.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 May 2010 00:11:32 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> 
> Having reconsidered the suspend blockers idea I came to the conclusion that
> in fact it was a workaround for three different problems.

But it is also a change of paradigm. The scheduler should strive to
have the system idle as long as possible to conserve battery. And
everything that does not serve the purpose of the device has to be
considered as not worth running, except if there are other
purpose-fullfilling tasks to run anyway.

 > 
> Thanks,
> Rafael

cheers,
Flo
