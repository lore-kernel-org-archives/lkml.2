Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1KZAkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 19:40:41 -0500
Received: from 11.mo1.mail-out.ovh.net ([188.165.48.29]:56843 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753937Ab1KZAkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 19:40:40 -0500
Date: Sat, 26 Nov 2011 00:01:08 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH] watchdog: fix nowayout setting in wm831x_wdt
Message-ID: <4ed01e34.4telR5MuxvRWCyfz%marc.vertes@sigfox.com>
References: <4ed01ce0.pLO/jX2YTtsMsYc8%marc.vertes@sigfox.com>
In-Reply-To: <4ed01ce0.pLO/jX2YTtsMsYc8%marc.vertes@sigfox.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2176645996181440303
X-Ovh-Remote: 78.224.61.197 (lys31-1-78-224-61-197.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrudefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhgjfgggtgfgsehtjeertddtredvnecuhfhrohhmpeforghrtgcugggvrhhtvghsuceomhgrrhgtrdhvvghrthgvshesshhighhfohigrdgtohhmqeenucffohhmrghinhepne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrtddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Vertes <marc.vertes@sigfox.com> wrote:

>  	if (nowayout)
> -		wm831x_wdt->status |= WDOG_NO_WAY_OUT;
> +		setbit(WDOG_NO_WAY_OUT, &wm831x_wdt->status);
set_bit(...) of course.

Regards,
--
Marc
