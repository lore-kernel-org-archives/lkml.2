Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab0ITUls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:41:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52235 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab0ITUlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:41:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nix <nix@esperi.org.uk>
Subject: Re: [Bug #18272] 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (ACPI idle?)
Date: Mon, 20 Sep 2010 22:40:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Venkatesh Pallipadi" <venki@google.com>
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera> <aRnAGz9xZ8K.A.lAF.897lMB@chimera> <87pqw8f94h.fsf@spindle.srvr.nix>
In-Reply-To: <87pqw8f94h.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009202240.42220.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 20, 2010, Nix wrote:
> On 20 Sep 2010, Rafael J. Wysocki said:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> 
> Resolved by 54ff7e595d763d894104d421b103a89f7becf47c in master,
> which is landing in 2.6.35.5 imminently.

Great, closing.

Thanks,
Rafael
