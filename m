Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1ANQjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:39:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54306 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab1ANQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=g8pj2cwBT7K9SA5rtzKRFlxZ73dDG/Vt9xPSQRUTvTDrxtTWpbUGqKkRCBjwvaWSpz
         l0ofS7UHw0O1Vx3HtGMASHnDEGAqoca9pKEgycnRTb3UMwOfm40nE9Cj+go0VAfr1rwh
         Ir/bbiNXFYuomZBRmndhyhUXOC2za27Uh1Ups=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [RFC PATCH 2/2] power_supply: Add new LED trigger charging-blink-solid-full
Date: Fri, 14 Jan 2011 18:37:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-gentoo-anarsoul; KDE/4.5.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>
References: <1294417697-4692-1-git-send-email-anarsoul@gmail.com> <1294417697-4692-3-git-send-email-anarsoul@gmail.com> <20110114161851.GA11087@oksana.dev.rtsoft.ru>
In-Reply-To: <20110114161851.GA11087@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101141837.25390.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 January 2011 18:18:51 Anton Vorontsov wrote:

> Strange, I got neither 0/2 nor 1/2.

Hmm, patches are definitely on ML, here's link to 1st patch on patchwork:
https://patchwork.kernel.org/patch/464481/

However, if you want, I can forward copy of 0/2 and 1/2 to you directly, but 
check your 'spam' folder first ;)

> Anyway, I'm fine with this particular patch, but to take 1/2 via
> battery-2.6.git I need Richard's Acked-by tag.

Ok

> > +		led_trigger_blink(psy->charging_blink_full_solid_trig,
> > +			&delay_on, &delay_off);
> 
> I think it's better to allow passing NULL to led_trigger_blink()
> and thus avoid delay_{on,off} dummy variables.

It mimics led_blink_set function, and I prefer to keep it this way (just to 
keep consistency), or change led_blink_set behavior.

Regards
Vasily
