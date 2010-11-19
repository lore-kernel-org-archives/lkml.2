Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab0KSUGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:06:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37921 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0KSUGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:06:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
Date: Fri, 19 Nov 2010 21:05:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera> <t78YtCSuOqN.A.AJ.q6b5MB@chimera> <alpine.SOC.1.00.1011191106540.26731@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1011191106540.26731@math.ut.ee>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011192105.42351.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Meelis Roos wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> > Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> > Submitter	: Meelis Roos <mroos@linux.ee>
> > Date		: 2010-08-19 21:03 (92 days old)
> > Message-ID	: <<alpine.SOC.1.00.1008192359310.19654@math.ut.ee>>
> > References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2
> 
> Still unfixed in mainline.

Thanks for the update.

Rafael
