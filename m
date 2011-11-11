Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1KKPTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:19:09 -0500
Received: from h1778886.stratoserver.net ([85.214.133.74]:45658 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1KKPTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:19:07 -0500
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] s3c-adc-battery: Add naive POWER_SUPPLY_PROP_PRESENT implementation
Date: Fri, 11 Nov 2011 16:18:56 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <201111100956.43979.heiko@sntech.de> <1320923106.2594.0.camel@anarsoul-laptop.Home> <20111110133052.GA31381@oksana.dev.rtsoft.ru>
In-Reply-To: <20111110133052.GA31381@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111111619.00388.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 10. November 2011, 14:30:52 schrieb Anton Vorontsov:
> On Thu, Nov 10, 2011 at 02:05:06PM +0300, Vasily Khoruzhick wrote:
> > On Thu, 2011-11-10 at 09:56 +0100, Heiko Stübner wrote:
> > > Userspace programs like upower seem to depend on the presence of the
> > > POWER_SUPPLY_PROP_PRESENT property.
> > > 
> > > The real presence of the battery cannot be sensed and all other
> > > routines of s3c-adc-battery simply expect it to be present.
> > > 
> > > Therefore we simply return 1, unless the battery struct is not present
> > > at all.
> > 
> > Looks OK for me,
> > 
> > > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > 
> > Acked-by: Vasily Khoruzhick <anarsoul@gmail.com>
> 
> I disagree. If the driver behaves like the hardware does not support
> hot-pluggable cells, then present property is not necessary.
> 
> Upowerd should look at the 'present' only if it is there; and if it
> is not, cells assumed to be always present.

[..]
 
> So, the problem is in upowerd, not this driver.

Thanks for your comment. I will therefore take this matter up with the upower-
guys.

Thanks
Heiko
