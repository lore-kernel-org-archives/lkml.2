Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0HDGEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:04:49 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:49426 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983Ab0HDGEs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:04:48 -0400
From: viresh kumar <viresh.kumar@st.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Armando Visconti <armando.visconti@st.com>,
        shiraz hashim <shiraz.hashim@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Date: Wed, 4 Aug 2010 14:04:23 +0800
Subject: RE: [PATCH resend] Watchdog: Adding support for ARM Primecell	SP805
 Watchdog
Thread-Topic: [PATCH resend] Watchdog: Adding support for ARM Primecell
	SP805 Watchdog
Thread-Index: AcsyMXJs0RU4MiC+QhqCeX6buU+oxgBaH7BH
Message-ID: <F6259B467C2CCE44A8F3D92A9BFE1D3D166FD0EBE7@EAPEX1MAIL1.st.com>
References: <1275465783-14052-1-git-send-email-viresh.kumar@st.com>
 <4C11B711.70907@st.com> <20100611053049.GM3788@infomag.iguana.be>
 <4C285A72.7030303@st.com> <20100628162430.GN3788@infomag.iguana.be>
 <20100718193425.GD24707@n2100.arm.linux.org.uk>
 <20100726184601.GS11857@infomag.iguana.be>
 <4C4E5B1E.4040004@st.com>,<20100802105704.GT30740@infomag.iguana.be>
In-Reply-To: <20100802105704.GT30740@infomag.iguana.be>
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

Hi Wim,


> After the discussion about the division: will there be a V2 of this patch or will V1 remain?

Yes, i will send V2 of this patch.
There is one change, inclusion of slab.h.

viresh.