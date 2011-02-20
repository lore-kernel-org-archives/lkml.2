Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1BTKvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 05:51:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39923 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab1BTKvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 05:51:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.37.1 s2disk regression (TPM)
Date: Sun, 20 Feb 2011 11:51:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: stefanb@linux.vnet.ibm.com,
        "linux-pm" <linux-pm@lists.linux-foundation.org>,
        srajiv@linux.vnet.ibm.com, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net
References: <4D60E93D.1050205@gmail.com> <201102201144.34043.rjw@sisk.pl> <4D60F108.9000106@gmail.com>
In-Reply-To: <4D60F108.9000106@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201102201151.11635.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 20, 2011, Jiri Slaby wrote:
> On 02/20/2011 11:44 AM, Rafael J. Wysocki wrote:
> > On Sunday, February 20, 2011, Jiri Slaby wrote:
> >> Hi,
> >>
> >> I'm unable to hibernate 2.6.37.1 unless I rmmod tpm_tis:
> >> [10974.074587] Suspending console(s) (use no_console_suspend to debug)
> >> [10974.103073] tpm_tis 00:0c: Operation Timed out
> >> [10974.103089] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -62
> >> [10974.103095] PM: Device 00:0c failed to freeze: error -62
> >>
> >> 2.6.37 worked fine. Going to revert 9b29050f8f7 (tpm_tis: Use timeouts
> >> returned from TPM) for testing.
> > 
> > Yes, this has been confirmed to cause suspend regressions to happen
> 
> OK, the revert works for me too... Are there any fixes?

No, and the author and maintainer have not been responding.  If that contiunes,
I'll simply ask Linus to revert it.

Thanks,
Rafael
