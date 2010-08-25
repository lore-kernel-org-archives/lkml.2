Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0HYNmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:42:44 -0400
Received: from smtp.witbe.net ([81.88.96.48]:37752 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab0HYNmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:42:42 -0400
Date: Wed, 25 Aug 2010 15:41:54 +0200
From: Paul Rolland <rol@as2917.net>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Roberto Oppedisano <roberto.oppedisano@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zou Nan hai <nanhai.zou@intel.com>,
        "Xiang Hai hao" <haihao.xiang@intel.com>,
        Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.35-rc6+: i915: Bisected regression
Message-ID: <20100825154154.032f2b5a@tux.DEF.witbe.net>
In-Reply-To: <201008241936.18681.thomas@m3y3r.de>
References: <201008011101.01429.thomas@m3y3r.de>
	<20100801151409.252be86b@tux.DEF.witbe.net>
	<4C559022.1010406@gmail.com>
	<201008241936.18681.thomas@m3y3r.de>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Tue, 24 Aug 2010 19:36:18 +0200
Thomas Meyer <thomas@m3y3r.de> wrote:

> On Sunday 01 August 2010 17:17:54 Roberto Oppedisano wrote:
> >   On 01/08/2010 15:14, Paul Rolland wrote:
> > > My machine has :
> > > 00:02.0 0300: 8086:2a42 (rev 07)
> > > 00:02.1 0380: 8086:2a43 (rev 07)
> > >
> > > 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
> > > Chipset Integrated Graphics Controller (rev 07) 00:02.1 Display
> > > controller: Intel Corporation Mobile 4 Series Chipset Integrated
> > > Graphics Controller (rev 07)
> > >
> > > (Dell Vostro 1520, BIOS Revision A04)
> > >
> > >>>   Is it suspend
> > >>> or resume that is unreliable?
> > >> suspend never finishes/hangs.
> 
> Seems to be fixed in 2.6.36-rc2. Probably by merge commit 
> 4238a417a91643e1162a98770288f630e37f0484.
> 
> Paul, Roberto: Could you please confirm this on your hardware?

I've just installed 2.6.36-rc2 on my machine, and I've tested a few
"Sleep", and so far, no problem any more...

So, I can't help you on the "is this the exact commit ?", but it is fixed
(or at least it looks as if ;)

Regards,
Paul
