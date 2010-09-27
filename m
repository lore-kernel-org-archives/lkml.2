Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141Ab0I0Tle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:41:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289Ab0I0Tld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:41:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [Bug #16228] BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
Date: Mon, 27 Sep 2010 21:40:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Brian Bloniarz" <brian.bloniarz@gmail.com>,
        "Yinghai Lu" <yinghai@kernel.org>
References: <onxdOCF6lb.A.vKB.a_6nMB@chimera> <UfOptYFtL6C.A.fEE.6D7nMB@chimera> <201009270945.40627.bjorn.helgaas@hp.com>
In-Reply-To: <201009270945.40627.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009272140.40570.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 27, 2010, Bjorn Helgaas wrote:
> On Sunday, September 26, 2010 02:33:08 pm Rafael J. Wysocki wrote:
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
> > Date		: 2010-06-16 17:57 (103 days old)
> > Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Patch		: https://patchwork.kernel.org/patch/189182/
> > 		  https://patchwork.kernel.org/patch/189232/
> > 		  https://patchwork.kernel.org/patch/189242/
> > 		  https://patchwork.kernel.org/patch/189252/
> 
> We plan to merge this patches soon after the 2.6.36 release, so
> this regression will still exist in 2.6.36.

Thanks for the info.

The bug is going to be listed until 2.6.36 is released, then.

Rafael
