Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1HJXK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:10:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45231 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab1HJXKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:10:24 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4E42F8AD.5050000@ti.com>
References: <1309995504.2496.1.camel@phoenix> <CAF+7xW=AXA9RgddR0HgFwWdRcy6v1hcDXc7Z7KXb1DTBuzH-Pg@mail.gmail.com>
 <1311955847.2712.12.camel@CNA0741383> <CAF+7xWkUO0d7Bp4a8-0cksZhhcQ-jb4XfRCEP=qCqb3_qb5RxQ@mail.gmail.com>
 <4E42F8AD.5050000@ti.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 11 Aug 2011 07:10:04 +0800
Message-ID: <CAF+7xW=FbaB6mx9k7mPFNb_yDrhyVps5wwHAU99j3D0dP2SDEg@mail.gmail.com>
Subject: Re: [PATCH 1/2 RESEND] regulator: aat2870: Fix the logic of checking
 if no id is matched in aat2870_get_regulator
To: Liam Girdwood <lrg@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jin Park <jinyoungp@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you check regulator git #for-linus. I applied a bunch of patches a few days ago and some for this device. I'll do a pull request for rc2 in a few days.

Just checked both #for-linus and #for-next, I'm sure these 2 patches
are missing.

below is the commit history for aat2870-regulator.c:
#for-linus
http://git.kernel.org/?p=linux/kernel/git/lrg/voltage-2.6.git;a=history;f=drivers/regulator/aat2870-regulator.c;h=5abeb3ac3e8da43df3d58bf677c3ac0e3d17116e;hb=9d92d3fc20b2095b75d66824e5cc34a9e088dea0

#for-next
http://git.kernel.org/?p=linux/kernel/git/lrg/voltage-2.6.git;a=history;f=drivers/regulator/aat2870-regulator.c;h=5abeb3ac3e8da43df3d58bf677c3ac0e3d17116e;hb=fc999b83799074832367d3cfd724c341c849a7da

Regards,
Axel
