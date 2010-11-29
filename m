Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0K2N3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:29:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53222 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0K2N3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:29:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:mime-version:content-type:content-transfer-encoding:message-id
         :date:to:cc:subject:in-reply-to:references:x-mailer;
        b=mMnkAKdIMD7fUtQVBHfjiWOzebfDdhtkXxyhTujloLUPWnuXZ7ZQXH+a0d90Hrut3z
         BHo6AR5yXJQPHnA2Y9tlsXf3IhXTPeX5DnUfPx/tYSqtqUmeRk9yLgBVPjetsM+YeEEi
         sKpzq7WqBQFr6lezQAh2lg3dto2sNaXaIpFBY=
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19699.43671.455291.972969@gargle.gargle.HOWL>
Date: Mon, 29 Nov 2010 18:58:55 +0530
To: Pavel Machek <pma@sysgo.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rudolf.marek@sysgo.com" <rudolf.marek@sysgo.com>,
        "cko@sysgo.com" <cko@sysgo.com>, "mfa@sysgo.com" <mfa@sysgo.com>,
        "anl@sysgo.com" <anl@sysgo.com>
Subject: Re: ath9k_htc vs. powerpc (was Re: working usb wifi card, that is still possible to buy)
In-Reply-To: <20101129125705.GB31518@pma.sysgo.com>
References: <20101124081616.GA30595@pma.sysgo.com>
	<20101124131320.GA2611@pma.sysgo.com>
	<4CED33E0.5040000@lwfinger.net>
	<20101126083125.GA28982@pma.sysgo.com>
	<20101126102026.GA11857@pma.sysgo.com>
	<20101126112737.GB11857@pma.sysgo.com>
	<19695.40541.335361.81396@gargle.gargle.HOWL>
	<20101126123706.GA19755@pma.sysgo.com>
	<20101129100159.GC28833@pma.sysgo.com>
	<19699.40557.302196.832862@gargle.gargle.HOWL>
	<20101129125705.GB31518@pma.sysgo.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> We know the code currently works on PC; but this adds conversions that
> are nop on PowerPC and do something on PC... so they should have no
> effect on PowerPC and could break PC...?

Well, I tested the patch on x86 and it seemed to work okay.
But yeah, it needs to be tested well.

Sujith
