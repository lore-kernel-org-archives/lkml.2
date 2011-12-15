Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1LOI1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:27:04 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:36789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab1LOI1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:27:00 -0500
Subject: Re: [PATCH] asus-wmi: explicitly set the wireless LED
From: Johannes Berg <johannes@sipsolutions.net>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Keng-Yu Lin <kengyu@canonical.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <CAHR064ivFUeGwNAfB1MZO0mrvo+sAcM-cZTjR9wZTaPyWRhzAA@mail.gmail.com> (sfid-20111215_092552_215332_009CBEB1)
References: <1323244922-2673-1-git-send-email-kengyu@canonical.com>
	 <CAHR064iBtSTv79BhXt9_mMWugD4U_xLCM4i1wE7PLnZM8pL57g@mail.gmail.com>
	 <1323937340.3337.3.camel@jlt3.sipsolutions.net>
	 <CAHR064ivFUeGwNAfB1MZO0mrvo+sAcM-cZTjR9wZTaPyWRhzAA@mail.gmail.com>
	 (sfid-20111215_092552_215332_009CBEB1)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 09:26:47 +0100
Message-ID: <1323937607.3337.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 09:25 +0100, Corentin Chary wrote:

> > static const char *rfkill_ledtrigname(struct rfkill *rfkill)
> > {
> > #ifdef CONFIG_RFKILL_LEDS
> >        return rfkill->ledtrigname;
> > #endif
> >        return NULL;
> > }

> Right, but is rfkill->ledtrigname really set somewhere ?
> 
> rfkill->led_trigger.name seems safer to use.

Hm, indeed -- looks like we can get rid of ledtrigname completely since
nothing ever touches it.

johannes

