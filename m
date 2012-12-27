Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab2L0QBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 11:01:34 -0500
Received: from mout.gmx.net ([212.227.15.18]:60441 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2L0QBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 11:01:32 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX19fozYSxq9fu4/LMsm5QhKuO2ij6qKEwrIVIEK2qa
	WqdKfdlMX27xGd
From: Marc Dietrich <marvin24@gmx.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] rtc: add RTC driver for TPS6586x
Date: Thu, 27 Dec 2012 16:56:10 +0100
Message-ID: <2152592.FqkQ6Iyssd@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-21-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50DC6242.1000404@nvidia.com>
References: <1356102748-722-1-git-send-email-ldewangan@nvidia.com> <7345841.MepJzddHFh@ax5200p> <50DC6242.1000404@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 December 2012 20:29:14 Laxman Dewangan wrote:
> On Thursday 27 December 2012 08:26 PM, Marc Dietrich wrote:
> > Hi Laxman,
> > 
> > On Friday 21 December 2012 20:42:28 you wrote:
> >> +
> >> +	/* Set epoch start as 00:00:00:01:01:2000 */
> >> +	rtc->epoch_start = mktime(2000, 1, 1, 0, 0, 0);
> > 
> > any reason why you hard coded it to 2000? All boards I know use 2009, so
> > with this patch, everyone needs to set his clock again.
> 
> No specific reason. If 2009 should be default then I can push patch to
> set it as 2009.

At least myself would appreciate this.

Stephen said on IRC, that this could be configurable via a property node from 
device tree (and also the IRQ which now comes from platform_data). Maybe this 
can be added later on. I really like to see this driver in mainline now.

You can also add a "Tested-By: Marc Dietrich <marvin24@gmx.de>"

Thanks

Marc

