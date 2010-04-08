Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab0DHTvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:51:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40840 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933243Ab0DHTvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:51:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [Bug #15480] [regression] Fails to boot properly unless given pci=nocrs
Date: Thu, 8 Apr 2010 21:54:15 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Yanko Kaneti" <yaneti@declera.com>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <JVS2s9dmTsP.A.pr.JvPvLB@chimera> <201004071602.22200.bjorn.helgaas@hp.com>
In-Reply-To: <201004071602.22200.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004082154.15714.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010, Bjorn Helgaas wrote:
> On Wednesday 07 April 2010 03:08:37 pm Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15480
> > Subject		: [regression] Fails to boot properly unless given pci=nocrs
> > Submitter	: Yanko Kaneti <yaneti@declera.com>
> > Date		: 2010-03-09 01:24 (30 days old)
> > Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Patch		: http://lkml.org/lkml/2010/3/11/512
> 
> This should be closed.  The fix is in Linus' tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d558b483d5a73f5718705b270cb2090f66ea48c8

Thanks, closing.

Rafael
