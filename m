Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab0GWUWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:22:36 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44512 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758372Ab0GWUWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:22:34 -0400
Date: Fri, 23 Jul 2010 13:21:48 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, Ben Blum <bblum@andrew.cmu.edu>,
        containers@lists.linux-foundation.org, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>,
        Paul Menage <menage@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Message-ID: <20100723202148.GA5216@count0.beaverton.ibm.com>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
 <20100722185301.GA528@suse.de>
 <AANLkTik07hZot_x0p7xJuY8s4f8pGRd2Mn1+jYfHH2iq@mail.gmail.com>
 <20100722191200.GA5609@suse.de>
 <20100722214821.GB14303@count0.beaverton.ibm.com>
 <AANLkTikluqTBi3XsU-OT_IJuBdkURkHpM3ut-8ratnzr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikluqTBi3XsU-OT_IJuBdkURkHpM3ut-8ratnzr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 01:10:43AM +0200, Kay Sievers wrote:
> On Thu, Jul 22, 2010 at 23:48, Matt Helsley <matthltc@us.ibm.com> wrote:
> > So I'd suggest
> > those cgroup mounts go in /var/run/systemd/cgroup or something like that.
> 
> Impossible, we need it at bootup, and / is usually read-only, and /var
> might even be behind the network we need to bring up.
> 
> It needs to be on tmpfs mounted on the rootsfs, or in any of the
> virtual fss we have to mount anyway, so /sys/fs seems a good place.

Ahh, excellent point. Indeed, /sys/fs seems fine then.

Cheers,
	-Matt Helsley

