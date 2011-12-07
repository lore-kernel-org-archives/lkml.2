Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab1LGK5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:57:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59107 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab1LGK5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:57:51 -0500
MIME-Version: 1.0
In-Reply-To: <17A5987AD917BF4DB82CC60AED33D5E107096E44@008-AM1MPN1-021.mgdnok.nokia.com>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
	<1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
	<17A5987AD917BF4DB82CC60AED33D5E107096E44@008-AM1MPN1-021.mgdnok.nokia.com>
Date: Wed, 7 Dec 2011 12:57:50 +0200
Message-ID: <CAMP44s0NcHug_JKw27egZ3GOXTTk=Cu=T6CjeYqj0Vu4Y1z4YA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
From: Felipe Contreras <felipe.contreras@gmail.com>
To: kalle.jokiniemi@nokia.com
Cc: felipe.contreras@nokia.com, linux-kernel@vger.kernel.org,
        heikki.krogerus@nokia.com, cbouatmailru@gmail.com, tony@atomide.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 9:14 AM,  <kalle.jokiniemi@nokia.com> wrote:
> Reverting this patch will cause 14,7mA leak from the ISP1704 USB transceiver. I did test at the time that USB networking was ok on MeeGo 1.1 based (MeeGo community edition N900) release and this patch. Though can't help debugging this now, sorry.
>
> If you guys are not concerned with use time, no problem with this patch.

I think USB networking is more important that 14.7mA leak. So, my
setup is very simple, I build a basic user-space system with buildroot
that basically just has a shell (busybox), I configure usb0 as usual,
and it doesn't work from the PC side. Also, I never see the message
saying that the link was detected.

I tried a few things, perhaps I could try building with ISP1704
built-in, and try g_nokia instead of g_ether, but regardless of the
results, I think the patch should be reverted because it doesn't work
on some setups (mine).

-- 
Felipe Contreras
