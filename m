Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0IJSL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:11:57 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:37854 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011Ab0IJSL4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:11:56 -0400
From: Mattias WALLIN <mattias.wallin@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 10 Sep 2010 20:11:48 +0200
Subject: SV: [PATCH 2/3] MFD: AB8500 debugfs
Thread-Topic: [PATCH 2/3] MFD: AB8500 debugfs
Thread-Index: ActRB1tJ76VhrE6dQCKzDs43Etn/IwACtM3k
Message-ID: <33A307AF30D7BF4F811B1568FE7A9B181C357DCD@EXDCVYMBSTM006.EQ1STM.local>
References: <1284134031-8979-1-git-send-email-mattias.wallin@stericsson.com>,<20100910164352.GG23903@sirena.org.uk>
In-Reply-To: <20100910164352.GG23903@sirena.org.uk>
Accept-Language: sv-SE, en-US
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Might it be sensible to just unconditionally enable this if debugfs is
> enabled?

Do you mean remove the Kconfig part and instead have a Makefile with:

+obj-$(CONFIG_DEBUG_FS)     += ab8500-debugfs.o

If so it is ok with me.

By the way, I realized after sending the patchesl that Sam asked me to put you guys on CC.
Totally missed that.
I also got a acked-by you so should I add your acked-by to patch 1/3?

Trying to learn. Linus W have fixed all these practical things for me priviously.