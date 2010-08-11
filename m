Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab0HKCN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:13:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58030 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab0HKCNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:13:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Wed, 11 Aug 2010 04:11:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
References: <AANLkTinQD3ggLFVd2KvX95U2B_j=ZJquZgiBGieukJ+r@mail.gmail.com> <201008100453.11958.rjw@sisk.pl> <AANLkTi=UApkc7_qeeXikP7kAnYW2TOXvVQu91UiBr2LV@mail.gmail.com>
In-Reply-To: <AANLkTi=UApkc7_qeeXikP7kAnYW2TOXvVQu91UiBr2LV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008110411.38382.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 10, 2010, Arve Hjønnevåg wrote:
> 2010/8/9 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday, August 09, 2010, Arve Hjønnevåg wrote:
...
> 
> > Anyway, as I said I'm not opposed to the idea of using a special type of
> > objects for collecting debug information on wakeup events, so please free to
> > submit patches modifying the current mainline kernel code in that direction.
> >
> 
> How do you prefer to handle your pci wakeup events? Add a handle to
> every device or pci device? Or use a global handle to avoid the race
> and report wakeup events for debugging separately?

The latter, maybe?

Thanks,
Rafael
