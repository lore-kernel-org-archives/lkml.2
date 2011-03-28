Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1C1QM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:12:56 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56993 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1C1QMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YPx04tVUiN2fg4J2pjH/3IPz8zS4+ScMhmAf7h91dugyHNq2ctgskvkSr6rChpEsN0
         CaKZVqTqqaj549+Q0MPDl1egOD8Ts485JKph2lXjqeL8xXoIn+cyZGmDyfDRQBDZDFHK
         0L7hNk8Ot7vX3E+bZiBOeLrnu4dBDd6NE4Gd0=
MIME-Version: 1.0
In-Reply-To: <20110120074503.GD30522@core.coreip.homeip.net>
References: <AANLkTi=fjL0yxXWrDddafdBs7biJ326sXjaagTseVEVg@mail.gmail.com>
	<20110117190849.GB27245@core.coreip.homeip.net>
	<AANLkTindwH2X79vZTBHU04oomxqV=RchRVEwrDEcntVX@mail.gmail.com>
	<20110120074503.GD30522@core.coreip.homeip.net>
Date: Mon, 28 Mar 2011 09:12:54 -0700
Message-ID: <AANLkTi=zCbRx-gTxPAUfSXJV4bRV8-bk3TqV=etybu7y@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Additional TOS1900 devices support
From: Azael Avalos <coproscefalo@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Any updates on this patch?
I just saw a git-pull request, but I haven't seen this patch merged (yet).

I have a slightly updated patch (with suspend/resume functions added
to workaround some issues on some Toshiba Netbooks) with some
testing done by Seth Forshee, just in case that I need to resend.


Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
