Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1GNJQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:16:46 -0400
Received: from mail.bbaw.de ([194.95.188.6]:59707 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab1GNJQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:16:44 -0400
Date: Thu, 14 Jul 2011 11:16:42 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Message-Id: <20110714111642.83335f2a.taeuber@bbaw.de>
In-Reply-To: <20110706091117.9caa1d69.taeuber@bbaw.de>
References: <20110606095127.21d23a70.taeuber@bbaw.de>
	<201106060559.03131.gene.heskett@gmail.com>
	<20110606130628.e86f0c67.taeuber@bbaw.de>
	<201106060920.32257.gene.heskett@gmail.com>
	<20110606155610.69a0d17a.taeuber@bbaw.de>
	<20110607124354.06ed074e.taeuber@bbaw.de>
	<20110701102323.3db579ad.taeuber@bbaw.de>
	<20110701151313.2afd48e0.taeuber@bbaw.de>
	<20110701163719.27afc580.taeuber@bbaw.de>
	<20110704153923.b929ce5d.taeuber@bbaw.de>
	<62378.1309905287@turing-police.cc.vt.edu>
	<20110706091117.9caa1d69.taeuber@bbaw.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.6.6; VDF: 7.11.11.129; host: mailhub); id=16841-2DjHQl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody.

In the meantime I received a driver from areca. It's split into GPLed source
and precompiled object files.

I still get the same problems (and additional ones) with this driver as with
the mvsas driver. The log output differs but in the end it stalls the disks.

I fear that exchanging the hba with another one from LSI or the like I will
get the same problem. But I can't effort such a card just for testing.

I have a complete dmesg output if someone is interested.

What can I do?????

Thanks
Lars

Am Wed, 6 Jul 2011 09:11:17 +0200
Lars Täuber <taeuber@bbaw.de> schrieb:
> Hi Valdis,
> 
> Am Tue, 05 Jul 2011 18:34:47 -0400
> Valdis.Kletnieks@vt.edu schrieb:
> > On Mon, 04 Jul 2011 15:39:23 +0200, Lars =?UTF-8?B?VMOkdWJlcg==?= said:
> > 
> > > 1.
> > > * Ultrastar 7K3000 attached to onboard AMD_AHCI
> > > * dd if=/dev/zero of=/dev/sde
> > > * dd told write speed of: 15.7MB/s
> > > * no error after half an hour
> > > 
> > > 2.
> > > * Ultrastar 7K3000 attached to PCIe to sata_mv controller
> > > * dd if=/dev/zero of=/dev/sda
> > > * dd told write speed of: 6.5MB/s
> > > * no error but strange log: dmesg-PCIe-sata_mv.log.gz
> > > 
> > > 3.
> > > * Ultrastar 7K3000 attached to PCIe areca SAS HBA (mvsas)
> > > * dd if=/dev/zero of=/dev/sdg
> > > * dd told write speed of: 1.3MB/s
> > > * errors: dmesg-PCIe-mvsas.log.gz
> > 
> > Umm.. was this the *same* Ulstrastar disk connected 3 different ways?  And
> > how exactly was it connected in each case? (Trying to rule out flaky disks
> > if it was 3 different disks, or a hardware/cabling issue specific to the
> > areca controller)
> 
> No it wasn't the same disk but drives of identical type and version and with
> same firmware.
> All the problems I came across during my odyssey could be different ones.
> The most recent could be related to the mvsas driver.
> 
> See https://bugzilla.kernel.org/show_bug.cgi?id=14534#c11 and following.
> 
> Thanks
> Lars
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
Jägerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
