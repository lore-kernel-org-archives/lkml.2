Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0ITUpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:45:52 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40622 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab0ITUpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:45:51 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #16228] BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
Date: Mon, 20 Sep 2010 14:44:58 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Brian Bloniarz" <brian.bloniarz@gmail.com>,
        "Yinghai Lu" <yinghai@kernel.org>, chemobejk@gmail.com
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera> <aRnAGz9xZ8K.A.B1G.qB8lMB@chimera>
In-Reply-To: <aRnAGz9xZ8K.A.B1G.qB8lMB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009201445.00677.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 20, 2010 01:57:17 pm Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16228
> Subject		: BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
> Submitter	: Brian Bloniarz <brian.bloniarz@gmail.com>
> Date		: 2010-06-16 17:57 (97 days old)
> Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>

The four patches here: https://patchwork.kernel.org/patch/189182/
should resolve this problem.  They've been tested by Stefan Becker.

Bjorn
