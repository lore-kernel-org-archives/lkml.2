Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748Ab0I0Pqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:46:37 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11051 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724Ab0I0Pqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:46:36 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #16228] BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
Date: Mon, 27 Sep 2010 09:45:40 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Brian Bloniarz" <brian.bloniarz@gmail.com>,
        "Yinghai Lu" <yinghai@kernel.org>
References: <onxdOCF6lb.A.vKB.a_6nMB@chimera> <UfOptYFtL6C.A.fEE.6D7nMB@chimera>
In-Reply-To: <UfOptYFtL6C.A.fEE.6D7nMB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009270945.40627.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 26, 2010 02:33:08 pm Rafael J. Wysocki wrote:
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
> Date		: 2010-06-16 17:57 (103 days old)
> Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Patch		: https://patchwork.kernel.org/patch/189182/
> 		  https://patchwork.kernel.org/patch/189232/
> 		  https://patchwork.kernel.org/patch/189242/
> 		  https://patchwork.kernel.org/patch/189252/

We plan to merge this patches soon after the 2.6.36 release, so
this regression will still exist in 2.6.36.
