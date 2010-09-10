Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0IJS1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:27:49 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:48836 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426Ab0IJS1r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:27:47 -0400
From: Mattias WALLIN <mattias.wallin@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 10 Sep 2010 20:27:38 +0200
Subject: SV: SV: [PATCH 2/3] MFD: AB8500 debugfs
Thread-Topic: SV: [PATCH 2/3] MFD: AB8500 debugfs
Thread-Index: ActRE+FwOsH3afq+QNSjUZEATbA3ZQAAR9am
Message-ID: <33A307AF30D7BF4F811B1568FE7A9B181C357DCE@EXDCVYMBSTM006.EQ1STM.local>
References: <1284134031-8979-1-git-send-email-mattias.wallin@stericsson.com>
 <20100910164352.GG23903@sirena.org.uk>
 <33A307AF30D7BF4F811B1568FE7A9B181C357DCD@EXDCVYMBSTM006.EQ1STM.local>,<20100910181325.GA11584@rakim.wolfsonmicro.main>
In-Reply-To: <20100910181325.GA11584@rakim.wolfsonmicro.main>
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

>Pretty much; probably needs to be slightly more involved than that to
>make sure the selection lines up with the core but certainly the same
>effect for users.

Sorry I don't follow.
But after thinking about it I realize that only changing the Makefile is not a good idea
I need ifdefs in the .c file for avoiding build problems. Isn't the first solution with Kconfig better?