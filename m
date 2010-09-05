Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0IEItq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 04:49:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16360 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab0IEIto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 04:49:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Sun, 05 Sep 2010 01:48:52 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>
Date: Sun, 5 Sep 2010 01:49:36 -0700
Subject: RE: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC
Thread-Topic: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC
Thread-Index: ActM1vUagaLGP8MBQ1G0T1TBnEqVbQAAEmuA
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702CF4B6524@HQMAIL01.nvidia.com>
References: <1283448586-14613-1-git-send-email-rklein@nvidia.com>
 <20100902174736.GA28649@oksana.dev.rtsoft.ru>
 <E88A1D35AF5437468E5B14C7C4BA61C702CF4B651C@HQMAIL01.nvidia.com>
 <20100905084707.GA24817@opensource.wolfsonmicro.com>
In-Reply-To: <20100905084707.GA24817@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, sorry I somehow missed that email.

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: Sunday, September 05, 2010 1:47 AM
To: Rhyland Klein
Cc: Anton Vorontsov; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org; olof@lixom.net; Andrew Chew; khali@linux-fr.org
Subject: Re: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC

On Sat, Sep 04, 2010 at 02:00:47PM -0700, Rhyland Klein wrote:

> Mark, have you had a chance to double check my changes based on the comments you made? 

Yes: http://lkml.org/lkml/2010/9/3/136
