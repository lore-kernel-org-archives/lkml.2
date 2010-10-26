Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab0JZSUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:20:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57415 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab0JZSUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:20:10 -0400
Date: Tue, 26 Oct 2010 20:19:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
Message-ID: <20101026181957.GC3658@aftab>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <20101026175639.GF1637@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026175639.GF1637@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 01:56:39PM -0400, Markus Trippelsdorf wrote:
> There is also: acf01734b1747b1ec4be6f159aff579ea5f7f8e2 but I'm not
> sure if this commit is really relevant.

This shouldn't be at fault since your detected core frequency printed
after the TSC PIT calibration looks fine:

Oct 24 10:19:05 arch kernel: Fast TSC calibration using PIT
Oct 24 10:19:05 arch kernel: Detected 3211.206 MHz processor.

The changeset above removes the recalibration which was only required by
very early F10h's (and yours is not).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
