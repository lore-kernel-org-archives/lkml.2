Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab1KVOq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:46:28 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:28238 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753364Ab1KVOq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:46:27 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ViDR_r4VM1llblhQOhSKKjmJkICY08iJjWbYe2Z3DJJ9SpT
 D7jNDMITCdQq8zHWIOURU2oyT_vpM3CBQt2lh6BlqAVC5.QReI97Sg7tO6n5
 .oE9wEX..Q6t7RaaBt315sOCuzDTvv_ZwqwX4RT4sycXsmoEg6c2l.25cLaN
 W02D0n95_wpX1jyGrGlrY7xhVGC.ws4crwpqzd60nvoh9gPHM1s.ZbDqBWNC
 wO5KiG35VrLQ6hjPek.0wDfTDjLXwTQZL2GmW8RCCtmL8xS1Xv6noWS.CfsV
 K6Yu_PCC7jTIpFBMH1cVYYvtsqur5VJj6hS7JwUWlOJKI.xXAtidifEsP6l_
 SetpVICNYu_.Ek.cHf2ElouknaoMMXbnvQf3ML7igB34OThY0ZxBDufmJyK6
 mD8mb2VnA0oZMXcM0CcMPGQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 08:46:22 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <1321955185.2474.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1111220844400.25785@router.home>
References: <20111121161036.GA1679@x4.trippels.de>  <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121173556.GA1673@x4.trippels.de>  <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
  <20111121185215.GA1673@x4.trippels.de>  <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop>  <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>  <alpine.DEB.2.00.1111212105330.19606@router.home>  <20111122084513.GA1688@x4.trippels.de>
  <1321954729.2474.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1321955185.2474.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> I trigger a bug in less than 10 secondes, with this running while a
> "make -j16 " kernel build is run.
>
> while :; do slabinfo -v; done

Hmm.... Yeah there was limited testing on the debug features. There could
be something amiss there. Need to review the validation interactions with
the new code.


