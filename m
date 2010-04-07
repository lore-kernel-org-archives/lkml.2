Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0DGWCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 18:02:48 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:11378 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab0DGWCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 18:02:44 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15480] [regression] Fails to boot properly unless given pci=nocrs
Date: Wed, 7 Apr 2010 16:02:21 -0600
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Yanko Kaneti" <yaneti@declera.com>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <JVS2s9dmTsP.A.pr.JvPvLB@chimera>
In-Reply-To: <JVS2s9dmTsP.A.pr.JvPvLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004071602.22200.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 April 2010 03:08:37 pm Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15480
> Subject		: [regression] Fails to boot properly unless given pci=nocrs
> Submitter	: Yanko Kaneti <yaneti@declera.com>
> Date		: 2010-03-09 01:24 (30 days old)
> Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Patch		: http://lkml.org/lkml/2010/3/11/512

This should be closed.  The fix is in Linus' tree:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d558b483d5a73f5718705b270cb2090f66ea48c8
