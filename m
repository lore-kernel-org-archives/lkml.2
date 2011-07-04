Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1GDOIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:08:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40336 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab1GDOIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:08:20 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: [PATCH v6 08/18] mfd: twl6040: Add initial support
Date: Mon, 4 Jul 2011 17:08:17 +0300
Message-ID: <1650114.SY7VdjHPHs@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110704114844.GA3021@sortiz-mobl>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com> <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com> <20110704114844.GA3021@sortiz-mobl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Monday 04 July 2011 13:48:44 Samuel Ortiz wrote:
> I don't see the value of those 3 inline functions. Removing them would make
> the code actually more understandable (especially for the 2nd one).

Is it OK for you if I fix these as a follow-up series, so I do not need to 
rewrite this series, and resend it?

-- 
Péter


