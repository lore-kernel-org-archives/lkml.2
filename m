Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab1FIH4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:56:31 -0400
Received: from mail.bbaw.de ([194.95.188.6]:33169 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1FIH4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:56:30 -0400
Date: Thu, 9 Jun 2011 09:56:26 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Message-Id: <20110609095626.1eea731c.taeuber@bbaw.de>
In-Reply-To: <20110608213905.GA26654@khazad-dum.debian.net>
References: <20110606095127.21d23a70.taeuber@bbaw.de>
	<20110608123003.3569604f.taeuber@bbaw.de>
	<20110608213905.GA26654@khazad-dum.debian.net>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.5.12; VDF: 7.11.9.105; host: mailhub); id=11270-MxOEAp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

thanks for your reply.

Am Wed, 8 Jun 2011 18:39:05 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> schrieb:

> On Wed, 08 Jun 2011, Lars Täuber wrote:
> > Am I the only one using SW-RAID6 and having this problem?
> 
> Well, ask Arecca if these disks have problems with their RAID
> controllers, and whether they can help you get hold of firmware updates
> for the WD disks.
> 
> The WD RE4-GP 2TB might not be the only WD RE4 disk with quirky
> firmware.
> 
> http://blog.fastmail.fm/2009/11/06/western-digital-re4-gp-2tb-drive-problems-and-solutions/
> http://kb.lsi.com/KnowledgebaseArticle15592.aspx?Keywords=Re4+firmware

According to this thread:
http://community.wdc.com/t5/Other-Internal-Drives/WD2002FYPS-firmware/td-p/63330
the WD2002FYPS-02W3B0 models seem to be really bad for RAID systems.

The former models with the most recent firmware seem to work somehow:
Model: WD2002FYPS-01U1B1
FW:    04.05G05

Seems I have to exchange the drives to get a working array.

I got an reply from Western Digital that all my disks have the most recent
firmware available.

I wonder why I had the very same problem with Seagate Barracuda ES 320GB
drives!

Thanks again and sunny greatings to brazil.
Lars
