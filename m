Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab1AMT2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:28:38 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44049 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1AMT2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:28:35 -0500
Date: Thu, 13 Jan 2011 20:28:25 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Manoj Iyer <manoj.iyer@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113192825.GC30866@kryptos.osrc.amd.com>
References: <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
 <20110113172205.GA30866@kryptos.osrc.amd.com>
 <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com>
 <20110113175531.GD2006@aftab>
 <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
 <20110113183025.GE2006@aftab>
 <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
 <20110113185807.GA24720@srcf.ucam.org>
 <20110113190700.GB30866@kryptos.osrc.amd.com>
 <alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 08:13:42PM +0100, Thomas Gleixner wrote:
> > Well, Andreas did boot with 'hpet=verbose' on an affected machine here
> > and did a suspend/resume and the hpet config registers looked ok before
> > suspend and after resume. It might be that the HPET is temporarily
> > "insane" while resume lasts but we don't have any hard facts confirming
> 
> And you have no explanation at all why applying the irq pin routing
> quirk makes HPETs temporal insanity go away magically :)

But after the HPET counter wraps around, the machine is alive again.
Which means that the IRQ0 pin2 override is only temporarily needed after
resume... Strange.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
