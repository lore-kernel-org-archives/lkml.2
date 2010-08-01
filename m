Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab0HANZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 09:25:50 -0400
Received: from smtp.witbe.net ([81.88.96.48]:59609 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab0HANZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 09:25:48 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Aug 2010 09:25:48 EDT
Date: Sun, 1 Aug 2010 15:14:09 +0200
From: Paul Rolland <rol@as2917.net>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zou Nan hai <nanhai.zou@intel.com>,
        Xiang Hai hao <haihao.xiang@intel.com>, Eric Anholt <eric@anholt.net>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.35-rc6+: i915: Bisected regression
Message-ID: <20100801151409.252be86b@tux.DEF.witbe.net>
In-Reply-To: <98E20220-BFC9-4231-AEF5-EB59588E6D2F@m3y3r.de>
References: <201008011101.01429.thomas@m3y3r.de>
	<4C555DA0.6020109@s5r6.in-berlin.de>
	<98E20220-BFC9-4231-AEF5-EB59588E6D2F@m3y3r.de>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Sun, 1 Aug 2010 12:51:36 +0200
Thomas Meyer <thomas@m3y3r.de> wrote:

> Am 01.08.2010 um 13:42 schrieb Stefan Richter <stefanr@s5r6.in-berlin.de>:
> 
> > Thomas, on what hardware did you observe the regression?
> 
> Is a Intel mobile express gm45 chipset.

My machine has :
00:02.0 0300: 8086:2a42 (rev 07)
00:02.1 0380: 8086:2a43 (rev 07)

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)

(Dell Vostro 1520, BIOS Revision A04)

> >  Is it suspend
> > or resume that is unreliable?
> suspend never finishes/hangs.
and is randomly suffering from exactly the same problems...

So, I've applied your hint (in i915_drv.h), rebuilt a kernel, booted, and
I've now successfully managed to go thru several suspend/resume cycles
without having the machine hanging while suspend !

Will check in the long term, but so far, it's a win !

Thx,
Paul

