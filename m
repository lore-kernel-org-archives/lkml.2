Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0K2MQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:16:18 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:48364 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0K2MQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:mime-version:content-type:content-transfer-encoding:message-id
         :date:to:cc:subject:in-reply-to:references:x-mailer;
        b=JJS2Vh9wtO4CZ+9avU2BJ9B08YM1SieI68hGtoK9po5vxDl0cHbf6tJSUrxL7bnAxp
         SDLABJbxOCUU2nlPs6960Dn9JodXI7nKfmP7PLvG+ER4sDiEPuxvDghHz5fhLLPK89Oa
         LNOtRIsmwU10KsEwysS7S7UvDhZ0sScF7skcQ=
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19699.39300.972745.297319@gargle.gargle.HOWL>
Date: Mon, 29 Nov 2010 17:46:04 +0530
To: Pavel Machek <pma@sysgo.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rudolf.marek@sysgo.com" <rudolf.marek@sysgo.com>,
        "cko@sysgo.com" <cko@sysgo.com>, "mfa@sysgo.com" <mfa@sysgo.com>,
        "anl@sysgo.com" <anl@sysgo.com>
Subject: Re: ath9k_htc vs. powerpc (was Re: working usb wifi card, that is still possible to buy)
In-Reply-To: <20101126123706.GA19755@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
	<20101124081616.GA30595@pma.sysgo.com>
	<20101124131320.GA2611@pma.sysgo.com>
	<4CED33E0.5040000@lwfinger.net>
	<20101126083125.GA28982@pma.sysgo.com>
	<20101126102026.GA11857@pma.sysgo.com>
	<20101126112737.GB11857@pma.sysgo.com>
	<19695.40541.335361.81396@gargle.gargle.HOWL>
	<20101126123706.GA19755@pma.sysgo.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> > > Sujith, I see you fought with endianness issues on ath9k_htc
> > > driver. Was you able to test it on actual hardware? Should I try the
> > > version just after your commit?
> > 
> > No, I never had a chance to test the driver on a big-endian system.
> > I assume you are referring to this commit: "ath9k_htc: Fix sparse endian warnings" ?
> 
> Yes.
> 
> > Does using latest wireless-testing help ?
> 
> I updated to wireless-testing from today, and still same results.

A lot of structures in htc.h are not handled in an endian-safe manner.
I'll send a patch fixing them and maybe things will improve.

Sujith
