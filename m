Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0IOMci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:32:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab0IOMcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:32:36 -0400
Date: Wed, 15 Sep 2010 09:32:15 -0300
From: Glauber Costa <glommer@redhat.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Zachary Amsden <zamsden@redhat.com>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
Message-ID: <20100915123215.GC3688@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-11-git-send-email-zamsden@redhat.com>
 <4C8F3C03.50306@siemens.com>
 <4C904685.9090402@redhat.com>
 <4C907F3D.6070709@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C907F3D.6070709@web.de>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 10:09:33AM +0200, Jan Kiszka wrote:
> > In any case, I'll proceed with the forcing of unstable TSC and HPET
> > clocksource and see what happens.
> 
> I tried that before, but it did not trigger the issue that kvm-clock
> guests no longer boot properly. This only happens if the TSC is marked
> unstable.

even artificially marked unstable ?

