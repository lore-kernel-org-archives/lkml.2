Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1GFHLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:11:20 -0400
Received: from mail.bbaw.de ([194.95.188.6]:58149 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab1GFHLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:11:19 -0400
Date: Wed, 6 Jul 2011 09:11:17 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Message-Id: <20110706091117.9caa1d69.taeuber@bbaw.de>
In-Reply-To: <62378.1309905287@turing-police.cc.vt.edu>
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
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.5.34; VDF: 7.11.10.229; host: mailhub); id=13609-aYagrK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis,

Am Tue, 05 Jul 2011 18:34:47 -0400
Valdis.Kletnieks@vt.edu schrieb:
> On Mon, 04 Jul 2011 15:39:23 +0200, Lars =?UTF-8?B?VMOkdWJlcg==?= said:
> 
> > 1.
> > * Ultrastar 7K3000 attached to onboard AMD_AHCI
> > * dd if=/dev/zero of=/dev/sde
> > * dd told write speed of: 15.7MB/s
> > * no error after half an hour
> > 
> > 2.
> > * Ultrastar 7K3000 attached to PCIe to sata_mv controller
> > * dd if=/dev/zero of=/dev/sda
> > * dd told write speed of: 6.5MB/s
> > * no error but strange log: dmesg-PCIe-sata_mv.log.gz
> > 
> > 3.
> > * Ultrastar 7K3000 attached to PCIe areca SAS HBA (mvsas)
> > * dd if=/dev/zero of=/dev/sdg
> > * dd told write speed of: 1.3MB/s
> > * errors: dmesg-PCIe-mvsas.log.gz
> 
> Umm.. was this the *same* Ulstrastar disk connected 3 different ways?  And
> how exactly was it connected in each case? (Trying to rule out flaky disks
> if it was 3 different disks, or a hardware/cabling issue specific to the
> areca controller)

No it wasn't the same disk but drives of identical type and version and with
same firmware.
All the problems I came across during my odyssey could be different ones.
The most recent could be related to the mvsas driver.

See https://bugzilla.kernel.org/show_bug.cgi?id=14534#c11 and following.

Thanks
Lars
