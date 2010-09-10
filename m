Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab0IJGE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 02:04:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52291 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab0IJGE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 02:04:58 -0400
Date: Fri, 10 Sep 2010 08:04:19 +0200
From: Heinz Diehl <htd@fritha.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Heinz Diehl <htd@fancy-poultry.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100910060419.GA6368@fritha.org>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
 <20100714160704.GA10473@kryptos.osrc.amd.com>
 <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
 <20100718162239.GA21151@fancy-poultry.org>
 <20100719193454.GB19344@aftab>
 <20100720151405.GA6368@fancy-poultry.org>
 <20100908202923.GA4913@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908202923.GA4913@loge.amd.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100810 (GNU/Linux)
X-Provags-ID: V02:K0:aBi/64WLBAKoMvil2Z4Huh8HdwjvamnOj3x0owlIla1
 DZYt45rF4uVGBfdS4uMyUGYibox3XzFhy4Cik6tYtWqfxyRAar
 xOD8YtO/skaoiPeM6NvlQeCvorjNCg2Z588g8Rk/GT83y+u+GL
 CF0e1knpGiKsNidRKcNmzFoUEOAZYu/u4BwisIKggr3bj0Td/2
 PVIh9oSD2Z4808xnX+SJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.2010, Andreas Herrmann wrote: 

> Can you please boot using acpi_skip_timer_override kernel parameter?
> I recently had a chance to test on another Gigabyte mainbaord which
> showed similar symptoms as your system. I did not find suspicious
> things in HPET or APIC configuration but this kernel option worked
> around the problem.

Yeah!

This works around the problem on my system, too! Now it boots 
quite normally, with C1E enabled.

Thanks,
Heinz.
