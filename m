Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0GIVz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:55:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34111 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab0GIVz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:55:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: HDD not suspending properly / dead on resume
Date: Fri, 9 Jul 2010 23:53:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-pm@lists.osdl.org
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201007092347.29244.stephan.diestelhorst@gmail.com>
In-Reply-To: <201007092347.29244.stephan.diestelhorst@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201007092353.25731.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 09, 2010, Stephan Diestelhorst wrote:
> I wrote:
> >   I have an issue with suspend to RAM and I/O load on a disk. Symptoms
> > are that the disk does not respond to requests when woken up, producing
> > only I/O errors on all tested kernels (newest 2.6.35-rc4 (Ubuntu
> > mainline PPA build)):
> > 
> <snip>
>  
> > This can be triggered most reliably with multiple "direct" writes to
> > disk, I create the load with the attached script. If the issue is
> > triggered, suspend (through pm-suspend) takes very long.
> 
> Attached now...
> 
> > IMHO the interesting log output during suspend is:
> > [ 1674.700125] ata1.00: qc timeout (cmd 0xec)
> 
> Almighty google suggested to try "pci=nomsi", which seems to have
> cured the issue for me for now. Is that plausible? I'll keep this
> under observation.

Hmm.  How does your /proc/interrupts look like?

Also, do you have a link to this "Google suggestion"?

Rafael
