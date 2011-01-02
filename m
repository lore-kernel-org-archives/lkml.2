Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1ABVVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 16:21:04 -0500
Received: from mail.fuw.edu.pl ([193.0.80.14]:57878 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab1ABVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 16:21:03 -0500
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
Date: Sun, 2 Jan 2011 22:20:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <odW4v9b6arG.A.2bH.uE8GNB@chimera> <LbeBv-BNQpL.A.QKB.MI8GNB@chimera> <alpine.SOC.1.00.1101022215110.21244@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1101022215110.21244@math.ut.ee>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101022220.43565.rwys@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 02, 2011, Meelis Roos wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> > Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> > Submitter	: Meelis Roos <mroos@linux.ee>
> > Date		: 2010-08-19 21:03 (133 days old)
> > Message-ID	: <<<alpine.SOC.1.00.1008192359310.19654@math.ut.ee>>>
> > References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2
> > Patch		: http://marc.info/?l=linux-scsi&m=128590267608876&w=2
> 
> Still unpatched in mainline.

Thanks for the update.

Rafael
