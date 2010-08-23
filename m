Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0HWIpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:45:30 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:41488 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086Ab0HWIpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:45:23 -0400
From: Peppe CAVALLARO <peppe.cavallaro@st.com>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vamos-dev@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Date: Mon, 23 Aug 2010 10:44:55 +0200
Subject: RE: Dead Config Option STMMAC_ETH?
Thread-Topic: Dead Config Option STMMAC_ETH?
Thread-Index: ActCnx73fpTAzF9oQ9CfHoZYfNsMqQAAD91A
Message-ID: <107012446AC13D4C90B85672EAF5FB0E9E0FB3CCC0@SAFEX1MAIL3.st.com>
References: <86r5i6vegw.fsf@peer.zerties.org>
	<107012446AC13D4C90B85672EAF5FB0E9E0FB3CC9C@SAFEX1MAIL3.st.com>
 <86bp8tu3d9.fsf@peer.zerties.org>
In-Reply-To: <86bp8tu3d9.fsf@peer.zerties.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7N8jYA9011767

Hi Christian,

> -----Original Message-----
> From: Christian Dietrich [mailto:qy03fugy@stud.informatik.uni-erlangen.de]
> Sent: Monday, August 23, 2010 10:42 AM
> To: Peppe CAVALLARO
> Cc: Christian Dietrich; David S. Miller; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; vamos-dev@i4.informatik.uni-erlangen.de
> Subject: Re: Dead Config Option STMMAC_ETH?
> 
> Peppe CAVALLARO <peppe.cavallaro@st.com> writes:
> 
> [...]
> 
> > There is effort on this driver: currently the driver fully works on
> > STM platforms and starts working on ARM (SPEAr Kernels).  The driver
> > Kconfig actually depends on the CPU_SUBTYPE_ST40 but it built on x86
> > if remove this dependency (just verified).  In the past, I added this
> > dependency because the driver was initially tested on ST kernels
> > (where we continue to have the CPU_SUBTYPE_ST40) but I can review it
> > if you like.
> 
> Hm, i think it would be good if this dependency is removed, if it isn't
> needed, because then a allyes config would compile test this peace of
> code, and it can't die silently with changes around it.

No problem. I'll remove it and review the Kconfig asap.

Peppe

> 
> greetz didi
> --
> (Î» x . x x) (Î» x . x x) -- See how beatiful the lambda is
> No documentation is better than bad documentation
> -- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
