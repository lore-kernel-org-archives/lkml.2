Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1G0I03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 04:26:29 -0400
Received: from mail.bbaw.de ([194.95.188.6]:58256 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab1G0I00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 04:26:26 -0400
Date: Wed, 27 Jul 2011 10:26:24 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load - mvsas
 & 3.0-rc7
Message-Id: <20110727102624.971cc287.taeuber@bbaw.de>
In-Reply-To: <20110714123012.92787569.taeuber@bbaw.de>
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
	<20110714111642.83335f2a.taeuber@bbaw.de>
	<20110714123012.92787569.taeuber@bbaw.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.6.18; VDF: 7.11.12.130; host: mailhub); id=10619-BhKIGq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again!

This is an update for those who are interested.

I could find a hardware setup whith which the problems don't occur.
I exchanged the Supermicro H8SCM-F (AMD Opteron 4170HE) board with one with an
Intel CPU.

So it might be the chipset or the like.

All previous tested HBAs and SATA controller run just fine without any
strange messages on the intel based board.

The last try with the supermicro board was with an LSI SAS1068E PCI-Express
Fusion-MPT SAS HBA. It doesn't crash but did resets on the SATA connection
all the time. I could get 5,1MB write speed at most.

Best regards
Lars
