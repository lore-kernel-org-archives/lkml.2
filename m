Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab1KCPCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:02:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:24618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495Ab1KCPCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,450,1315206000"; 
   d="scan'208";a="32968878"
Date: Thu, 3 Nov 2011 15:12:41 +0000
From: Alan Cox <alan@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@googlemail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k/atari: SCC - Move Atari serial driver to staging
Message-ID: <20111103151241.70955a9f@bob.linux.org.uk>
In-Reply-To: <CAMuHMdWCb-As2U1rxtaa9QWznc_yD_MWG3-5AMy5LDvp1jJUXw@mail.gmail.com>
References: <alpine.DEB.2.00.1103201010001.13805@ayla.of.borg>
	<CAMuHMdWVchre0g6dE1j_s-+Wc3n17uifQLH6kRfJ9Q2DKfqBLQ@mail.gmail.com>
	<CAOmrzkJGhoBfqeTGROWdDXeL4HVJq2XaPJEtn0CzuNTOyCab9A@mail.gmail.com>
	<CAMuHMdWCb-As2U1rxtaa9QWznc_yD_MWG3-5AMy5LDvp1jJUXw@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So let's ask the experts: what will be the preferred serial driver
> framework in 2012?

The tty_port code should now handle all the nasty horrible
open/close/hangup logic for you. The serial midlayer uses that and is
gradually shrinking into a buffering/locking helper. The goal was to
*not* create yet another mid layer but to provide helpers that mid
layer and driver code alike can use sensibly.

So either ought to work out.

Alan
