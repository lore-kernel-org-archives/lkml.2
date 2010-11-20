Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab0KTISX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 03:18:23 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36312 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0KTISW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 03:18:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JRi6rESb9QpUMNHgdInV/4xw2mGHdveGIVkZqNUIUgrKu0YGDYz1nDsBz9LxVjrWMP
         ngSK4Svf8CIxHd+V/tXFlI0Dbb3Xvl+q3GwEImuHB1gN0Oy/tvKU+NKIXZoeBkMUJQb1
         dX0EyYsw2Jt4KO/Fl/yjNigwfjBwcNU5D2qDA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=d2xL_ZDhQtTE9Vt8SQkHGSM5oespHGT4m6Fav@mail.gmail.com>
References: <1290219413-21026-1-git-send-email-ccross@android.com>
	<AANLkTi=d2xL_ZDhQtTE9Vt8SQkHGSM5oespHGT4m6Fav@mail.gmail.com>
Date: Sat, 20 Nov 2010 08:18:21 +0000
X-Google-Sender-Auth: QVsQv-jKbct3JJioD7mSHyhEMh4
Message-ID: <AANLkTinasmWjczUuJ+pg9zZW5uU8qfxr1pQE9zSc0E_b@mail.gmail.com>
Subject: Re: [PATCH] ARM: Fix spinlock bad magic on disabling nonboot cpu
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Colin Cross <ccross@android.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 20, 2010, Kyungmin Park <kmpark@infradead.org> wrote:
> Hi,b
>
> I wonder why this patch is not merged previous rc cycles.
>
> it's already reported by Mr. Ham (a month or more ago) and get some
> acked for merge.
>
> To Rusell, Catalin,
> How to include or commit the latest kernel?

Just send the patch to Russell's patch system and Russell will pick it
up. I recall I already acked this patch.


-- 
Catalin
