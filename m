Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab0KKHhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 02:37:05 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55896 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab0KKHhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 02:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YMMI4tuV7tK4fr24sm6+JcxHAwHQUn8wEA0NKkUspGfk8buKgYIoSFXAoAvrkIieJv
         Sbv+Vpo5n5OAA9booPTxjB/stkpa5lhk8w5K4eivr/muZGSLK4aDCN0OfCELXiojBv/o
         JJeCfzD6tykhUrL15rvwae14yUDBJhrlYCLpk=
MIME-Version: 1.0
In-Reply-To: <20101110020018.GH5876@outflux.net>
References: <20101025235804.GA11760@outflux.net>
	<AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
	<20101109205008.GU5876@outflux.net>
	<AANLkTint3yM44CouOvG_oA2K=_iC9AJuw-sJoB_HTUMT@mail.gmail.com>
	<20101109234852.GC5876@outflux.net>
	<AANLkTinCLMGWWD=8do9pv0vnFMX8njYyNgsMS+VeRfpQ@mail.gmail.com>
	<1289351010.28590.81.camel@Joe-Laptop>
	<20101110020018.GH5876@outflux.net>
Date: Thu, 11 Nov 2010 09:37:02 +0200
X-Google-Sender-Auth: fT0KCPi6oQlNg05xK_MYKCVJigk
Message-ID: <AANLkTinvqpW-YA1+MZGeJwv4RG2onUKvhsD1TrOWBw6o@mail.gmail.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 4:00 AM, Kees Cook <kees.cook@canonical.com> wrote:
> If I fast-forward to today and run it, I get the same output you do.

Your patch had two parts and I only see one of them in mainline. Care
to resubmit?
