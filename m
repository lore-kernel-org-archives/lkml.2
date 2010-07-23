Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab0GWOUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:20:45 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34905 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0GWOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:20:43 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #16007] x86/pci Oops with CONFIG_SND_HDA_INTEL
Date: Fri, 23 Jul 2010 08:20:29 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Graham Ramsey" <ramsey.graham@ntlworld.com>,
        "Yinghai Lu" <yinghai@kernel.org>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera> <PRbv8sgxY6G.A.WmG.YWYSMB@chimera>
In-Reply-To: <PRbv8sgxY6G.A.WmG.YWYSMB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007230820.29465.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 23, 2010 06:15:50 am Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16007
> Subject		: x86/pci Oops with CONFIG_SND_HDA_INTEL
> Submitter	: Graham Ramsey <ramsey.graham@ntlworld.com>
> Date		: 2010-05-19 17:09 (66 days old)
> Handled-By	: Yinghai Lu <yinghai@kernel.org>
> 		  Bjorn Helgaas <bjorn.helgaas@hp.com>
> Patch		: https://patchwork.kernel.org/patch/105662/

This entry should remain on the regression list.

In my opinion, we should apply Graham's patch from comment 8:
  https://bugzilla.kernel.org/attachment.cgi?id=26508
which turns on "pci=use_crs" for this machine.

BIOS is telling us what configuration works, and we should
pay attention to it.  amd_bus.c has no hope of ever discovering
this working configuration.

Bjorn
