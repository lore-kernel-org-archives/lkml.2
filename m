Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1IUNdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:33:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60571 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753638Ab1IUNdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:33:13 -0400
Date: Wed, 21 Sep 2011 14:33:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: Re: Re: Re: Re: Re: [PATCH 07/17] ASoC: twl6040: Lower the
 initial gains
Message-ID: <20110921133311.GI4374@opensource.wolfsonmicro.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
 <2196705.QTf6PguHZl@barack>
 <20110921131744.GG4374@opensource.wolfsonmicro.com>
 <2000974.XKjcjOUu0O@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2000974.XKjcjOUu0O@barack>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 04:25:57PM +0300, Péter Ujfalusi wrote:
> On Wednesday 21 September 2011 14:17:44 Mark Brown wrote:
> > If I haven't commented on patches they're probably fine - normally I'm
> > waiting for review from Liam when this happens.

> He did acked the whole series, I'll add his acked-by to the patches.

Right for this particular series, but...

> Yes, I know.
> I'll only repost the changed patch (07/17), when I'm ready to not spam the 
> list with the rest.

...there's the obvious dependency from that patch in the rest of the
series so I can't apply it anyway.
