Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0JRGbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:31:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62078 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab0JRGa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:30:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=Hj1tgsAx0l0wVSjBh9X7wMYT0BtN/SbLkrryWZV+R39n2XNLRt4Z9T2OrLZ85m9nJd
         dIrKPZ7wmtkAeFJlvgTN5jf1wofuzCRGpE+Tl4Sp20ERiLUx4N9vC3bST4tqNz3HoO4d
         /KYxIezJcLnn+rTWtPyY/Vew5uT6x4td4t+j8=
MIME-Version: 1.0
In-Reply-To: <1287383251-28427-1-git-send-email-vapier@gentoo.org>
References: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com> <1287383251-28427-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 18 Oct 2010 02:30:37 -0400
X-Google-Sender-Auth: r7Ya9Vd1qfgW8m2e3mENJIP_g2Q
Message-ID: <AANLkTin5e8mORKCgq1ArkLiTfYkrrPAGaO07rYpwO73s@mail.gmail.com>
Subject: Re: [PATCH] vmlinux.lds.h: gather .data..shared_aligned sections in DATA_DATA
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam: i'm not trying to steal credit here ... if you want me to resend
with you as author + sob, lemme know.  i'd just like this issue fixed
already since 2.6.35 shipped with this broken setup.
-mike
