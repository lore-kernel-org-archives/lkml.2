Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab1C3UWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:22:35 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:55189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab1C3UWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:22:34 -0400
Subject: Re: [PATCH] acer-wmi: does not set persistence state by
 rfkill_init_sw_state
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Mickler <florian@mickler.org>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>,
        Corentin Chary <corentincj@iksaif.net>,
        "Lee, Chun-Yi" <jlee@novell.com>
In-Reply-To: <1301516277-1752-1-git-send-email-florian@mickler.org>
References: <1301516277-1752-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 22:22:32 +0200
Message-ID: <1301516552.3791.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 22:17 +0200, Florian Mickler wrote:
> From: Lee, Chun-Yi <joeyli.kernel@gmail.com>
> 
> Acer BIOS keeps devices state when system reboot, but reset to default
> device states (Wlan on, Bluetooth off, wwan on) if system cold boot.
> That means BIOS's initial state is not always real persistence.
> 
> So, removed rfkill_init_sw_state because it sets initial state to
> persistence then replicate to other new killswitch when rfkill-input
> enabled.
> After removed it, acer-wmi set initial soft-block state after rfkill
> register, and doesn't allow set_block until rfkill initial finished.
> 
> Reference: bko#31002
> 	https://bugzilla.kernel.org/show_bug.cgi?id=31002
> 
> Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Tested-by: OldÅich JedliÄka <oldium.pro@seznam.cz>

Your mailer messed up the character set, you're advertising
Content-Type: text/plain; charset=UTF-8
and then here putting the byte sequence
\xc3\x85\xc2\x99
instead of
\xc5\x99

for "ř".

johannes

