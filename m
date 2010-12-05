Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab0LEVwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 16:52:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55643 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab0LEVwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 16:52:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
Date: Sun, 5 Dec 2010 22:51:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera> <z3LGq_ncuOB.A.aSG.eD_-MB@chimera> <alpine.SOC.1.00.1012052300100.18105@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1012052300100.18105@math.ut.ee>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012052251.15604.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 05, 2010, Meelis Roos wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> 
> Yes, still present in yesterdays git.

Thanks for the update.

Rafael
