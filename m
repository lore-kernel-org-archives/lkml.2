Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1ACILp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 03:11:45 -0500
Received: from smtp.witbe.net ([81.88.96.48]:53272 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1ACILn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 03:11:43 -0500
Date: Mon, 3 Jan 2011 09:10:55 +0100
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Dave Airlie" <airlied@redhat.com>,
        "Keith Packard" <keithp@keithp.com>, rol@witbe.net
Subject: Re: [Bug #22542] [2.6.37-rc1] drm:i195 errors
Message-ID: <20110103091055.600c72d5@tux.DEF.witbe.net>
In-Reply-To: <201012311647.24673.rjw@sisk.pl>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
	<sV7shrPOroO.A.3WH.nA8GNB@chimera>
	<20101231113021.1f086baa@tux.DEF.witbe.net>
	<201012311647.24673.rjw@sisk.pl>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Fri, 31 Dec 2010 16:47:24 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Friday, December 31, 2010, Paul Rolland wrote:
> > Hello,
> > 
> > I'm now running 2.6.37-rc8, and I still have :
> > Dec 31 11:03:10 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR*
> > Attempting to mmap a purgeable buffer
> > 
> > as well as :
> > 
> > Dec 31 10:44:53 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR*
> > fixme: max PWM is zero. Dec 31 10:49:34 tux kernel:
> > [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
> 
> There were some last-minute fixes related to i915 added to the Linus' tree
> after 2.6.37-rc8.  Perhaps you can give them a try?

OK, currently running : 
[root@tux ~]# uname -a
Linux tux.DEF.witbe.net 2.6.37-rc8-00014-g3643e0e #1 SMP Sun Jan 2 16:25:04 CET 2011 x86_64 x86_64 x86_64 GNU/Linux

and I've seen that too :
Jan  3 08:27:30 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
Jan  3 08:27:30 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
Jan  3 08:27:30 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
Jan  3 08:27:30 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer

So, two possibilities :
 - 2.6.37-rc8-00014-g3643e0e is not what you wanted me to test,
 - the problem's still there.

Best,
Paul

-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

LinkedIn : http://www.linkedin.com/in/paulrolland
Skype    : rollandpaul

"I worry about my child and the Internet all the time, even though she's
too young to have logged on yet. Here's what I worry about. I worry that 10
or 15 years from now, she will come to me and say 'Daddy, where were you
when they took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 


