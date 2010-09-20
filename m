Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0ITVIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:08:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52342 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab0ITVH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:07:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [Bug #16228] BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
Date: Mon, 20 Sep 2010 23:07:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Brian Bloniarz" <brian.bloniarz@gmail.com>,
        "Yinghai Lu" <yinghai@kernel.org>, chemobejk@gmail.com
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera> <aRnAGz9xZ8K.A.B1G.qB8lMB@chimera> <201009201445.00677.bjorn.helgaas@hp.com>
In-Reply-To: <201009201445.00677.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009202307.09943.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 20, 2010, Bjorn Helgaas wrote:
> On Monday, September 20, 2010 01:57:17 pm Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16228
> > Subject		: BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
> > Submitter	: Brian Bloniarz <brian.bloniarz@gmail.com>
> > Date		: 2010-06-16 17:57 (97 days old)
> > Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> The four patches here: https://patchwork.kernel.org/patch/189182/
> should resolve this problem.  They've been tested by Stefan Becker.

Thanks, bug entry updated with the patch information.

Rafael
