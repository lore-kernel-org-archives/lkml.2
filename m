Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0HWHmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 03:42:49 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:46611 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab0HWHmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 03:42:47 -0400
X-Greylist: delayed 1707 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 03:42:46 EDT
From: Peppe CAVALLARO <peppe.cavallaro@st.com>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "vamos-dev@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Date: Mon, 23 Aug 2010 09:13:38 +0200
Subject: RE: Dead Config Option STMMAC_ETH?
Thread-Topic: Dead Config Option STMMAC_ETH?
Thread-Index: Acs4h5rmNQR0Hpp+QiaNR399Vg75HgKCZzDw
Message-ID: <107012446AC13D4C90B85672EAF5FB0E9E0FB3CC9C@SAFEX1MAIL3.st.com>
References: <86r5i6vegw.fsf@peer.zerties.org>
In-Reply-To: <86r5i6vegw.fsf@peer.zerties.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7N7gqel011395

Hi Christian,

> -----Original Message-----
> From: Christian Dietrich [mailto:qy03fugy@stud.informatik.uni-erlangen.de]
> Sent: Tuesday, August 10, 2010 2:29 PM
> To: David S. Miller; Peppe CAVALLARO; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: vamos-dev@i4.informatik.uni-erlangen.de
> Subject: Dead Config Option STMMAC_ETH?
> 
> Hi all!
> 
>         As part of the VAMOS[0] research project at the University of
> Erlangen we are looking at multiple integrity errors in linux'
> configuration system.
> 
>         I've been running a check on the drivers/net/stmmac sourcetree for
> config Items not defined in Kconfig and found such a case. Sourcecode
> blocks depending on these Items are not reachable from a vanilla
> kernel -- dead code. I've seen such dead blocks made on purpose
> e.g. while integrating new features into the kernel but generally
> they're just useless.
> 
> As far as i can see in drivers/net/stmmac/Kconfig STMMAC_ETH and several
> depending flags are dead in the linux vanilla kernel, because it depends
> on CPU_SUBTYPE_ST40, but there isn't a Kconfig option for that. But
> f96691872439ab2071171d4531c4a95b5d493ae5 suggests, that support for this
> ST40 plattform was removed in 2007.
> 
> There seems to be, that there was much effort on the stmmac drivers in
> the last few months, so i just wanted to ask if this problem is known.

There is effort on this driver: currently the driver fully works on STM platforms and starts working on ARM (SPEAr Kernels).
The driver Kconfig actually depends on the CPU_SUBTYPE_ST40 but it built on x86 if remove this dependency (just verified).
In the past, I added this dependency because the driver was initially tested on ST kernels (where we continue to have the CPU_SUBTYPE_ST40) but I can review it if you like.

Regards,
Peppe


> Regards
> 
>         Christian Dietrich
> 
> [0] http://vamos1.informatik.uni-erlangen.de
> --
> (Î» x . x x) (Î» x . x x) -- See how beatiful the lambda is
> No documentation is better than bad documentation
> -- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
