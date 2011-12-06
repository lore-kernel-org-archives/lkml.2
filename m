Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1LFPYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:24:39 -0500
Received: from mail.solarflare.com ([216.237.3.220]:22813 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753702Ab1LFPYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:24:37 -0500
Message-ID: <1323185069.7454.263.camel@deadeye>
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: prevent
 dobule restart of interface on FDX/HDX change
From: Ben Hutchings <bhutchings@solarflare.com>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Tue, 6 Dec 2011 15:24:29 +0000
In-Reply-To: <0b92136d69e509a6ce49b526e1834f0ec90b04a4.1323163127.git.LW@KARO-electronics.de>
References: <cover.1323163127.git.LW@KARO-electronics.de>
	 <0b92136d69e509a6ce49b526e1834f0ec90b04a4.1323163127.git.LW@KARO-electronics.de>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18562.005
X-TM-AS-Result: No--6.615600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You shouldn't repeat the subject of the whole series in the subject of
each patch.  Just put the name of the component you're changing (in this
case, 'fec: prevent dobule restart of interface on FDX/HDX change').

(Nitpick: typo in 'double'.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

