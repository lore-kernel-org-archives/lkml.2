Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab2JIVeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:34:21 -0400
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:50431 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600Ab2JIVeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:34:19 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2012 17:34:19 EDT
From: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
Organization: Sander & Lighting
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.6.1-rt1
Date: Tue, 9 Oct 2012 23:28:22 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0; KDE/4.8.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <alpine.LFD.2.02.1210091535140.10988@ionos>
In-Reply-To: <alpine.LFD.2.02.1210091535140.10988@ionos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210092328.22862.tim01@vlsi.informatik.tu-darmstadt.de>
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.10.9.212114
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas
> I'm pleased to announce the 3.6.1-rt1 release.
I also have to second the big thanks of Steven!

>    * Fix for a potential deadlock in mm/slab.c. This had been reported
>      as lockdep splats several times and stupidly ignored as a false
>      positive, but in fact it's a real (though almost impossible to
>      trigger) deadlock lurking.
Mh, just an unverified (i.e. i haven't had the time to dig into it) 
information from my side: I think i have been seeing a total lockup on an OOM 
condition. Is it possible that this possible deadlock
might have been triggered in such a condition more "reliably"?

Best regards
Tim
