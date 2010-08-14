Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0HNSPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 14:15:48 -0400
Received: from n3-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.156]:33061 "HELO
	n3-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753271Ab0HNSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 14:15:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 395113.33137.bm@omp124.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=J3tSyTFym5T8Zv8Cya7WBCnyfkdXdEO4kabr/rk6JK8hLBzCKvMGSQHBcZ/YwbZHyc51ZkS2NXr0LXaArzhSQyZdKaIu1rmFwvxfKnhih5k2gW24nsRJ2teZQlTV1/mfxX3i0iD6V+LYuXxTiFV2MlA4/BplkdKkdVMrMnkuOX8=;
Message-ID: <302795.95811.qm@web180309.mail.gq1.yahoo.com>
X-YMail-OSG: KyrccZkVM1lnXAFVtwVuP_M4B6Syn6x2fUnnC.2TCUUFeYh
 iWBwUHh.oO2SFrtgRLxnUQs6Xz0frnBcwoOzefU6uqwh6NJKUyKJQeOxw7aF
 BGtHiJ2zk1_BESmLzThYWtxHMvkO.JOEBAWxUSpWs2tglbaJKHZfmn9SEWD.
 exwrC8eQftGD4Bsrfd_nnE7Ogv_VKce6D.sUdKXnVoJ71rVxLHyrh8z51_TD
 Nvk1bDWc6TTaiBpqqB2sWPITyce6W4dGdndRXLqLSG8laPSbLPIsFGnVwLco
 N1O3c4qcWB7NjKJdEKERfFNo7kv9CZmg_5T4XGwwpXfiFPgGylZ8m8y6fAG_
 m.nd6pvLwTn6tabsYvwA-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 14 Aug 2010 11:15:43 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
To: paulmck@linux.vnet.ibm.com, Arjan van de Ven <arjan@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, James.Bottomley@suse.de,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
In-Reply-To: <20100814095351.6a996187@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 8/14/10, Arjan van de Ven <arjan@infradead.org> wrote:


> however I think you're making an assumption
> that there is a real difference between a deep idle state and "off"....
> 
> For modern x86 hardware, that assumption isn't
> really valid.

For ARM processors it's not unrealistic.  THey
tend to have idle states that place constraints on
peripherals and clocks which allow peripherals to run independently of CPUs.

I recall for example various processors that allow
USB to continue operating in one or more idle states, if the right clocks are active (and RAM).
Similarly with some other peripherals.  It may be
desirable to have I/O active while CPUs are idle.

Not all low power states map to x86/ACPI models;
and Linux hasn't accomodated that reality well.



