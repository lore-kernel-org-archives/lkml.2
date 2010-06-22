Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0FVWBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:01:15 -0400
Received: from p01c12o145.mxlogic.net ([208.65.145.68]:43966 "EHLO
	p01c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0FVWBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:01:14 -0400
X-MXL-Hash: 4c2132aa64479f7b-8135ffe480ed3a0542b31cd343b3299d641d0bd3
X-MXL-Hash: 4c2132a540125b6b-d3a891f7200d7c97f8714c473ed37de830a12ea1
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Greg KH <gregkh@suse.de>
Date: Tue, 22 Jun 2010 17:00:43 -0500
Subject: RE: Staging: rtl8192e/ieee80211: remove kernel version
 compatibility wrappers
Thread-Topic: Staging: rtl8192e/ieee80211: remove kernel version
 compatibility wrappers
Thread-Index: AcsSVKfbUgq8nXUbRZe4PCEJuzTkQwAADRqw
Message-ID: <0D753D10438DA54287A00B0270842697637165045E@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B02708426976370DCE440@AUSP01VMBX24.collaborationhost.net>
 <20100622214600.GA18841@kroah.com>
In-Reply-To: <20100622214600.GA18841@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010061701)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.180]
X-AnalysisOut: [v=1.0 c=1 a=yYB-YgN5oLcA:10 a=hO-oPbc3tlwA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=kj9zAlcOel0A:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=ZP16vw_y2b1-3dsx2m8A:9 a=UaVt03YI6lYRvM_IPK]
X-AnalysisOut: [99S4LcNFMA:4 a=CjuIK1q_8ugA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010 2:46 PM, Greg KH wrote:
> On Wed, Jun 09, 2010 at 10:45:43AM -0500, H Hartley Sweeten wrote:
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> 
>
> This doesn't apply at all, what tree is it against?

Hmm.. It's based on next-20100609 but it applies to next-20100622.

~/src/git/linux-next $ patch --dry-run -p1 -i ../patches/rtl8192e_ieee80211_remove_LINUX_VERSION_CODE.patch 
patching file drivers/staging/rtl8192e/ieee80211/dot11d.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211.h
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
patching file drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
patching file drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c

> confused,

Same here.. ;-)

Hartley