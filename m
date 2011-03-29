Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1C2LYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:24:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41717 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1C2LYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=o54lac2FW18+zDm3uVPDsNj5aaglU3bZ1GcKlh0Pug8WeMoWv3ytqsPUDRwU8l73Qa
         /U5FX2uTEtcbLF3N5qrYpjxOJLXHfG2ipewzEufYbJJjE1DsHSrWU7JoisWCA9f23mIk
         t2azn8xHji14q9FZ3iSeG14UbbWcgPx2cjsHg=
MIME-Version: 1.0
In-Reply-To: <AANLkTimaR8PW+N=tYwrD4+rXmzfm5uFv7a6SD-fWUG7B@mail.gmail.com>
References: <1300978173-9983-1-git-send-email-dbaluta@ixiacom.com>
	<20110329073632.GB10163@osiris.boeblingen.de.ibm.com>
	<AANLkTi=Kr5DQrZW+d=u-fyYcDNQogBj=TFr1_25+Z4Uw@mail.gmail.com>
	<AANLkTimaR8PW+N=tYwrD4+rXmzfm5uFv7a6SD-fWUG7B@mail.gmail.com>
Date: Tue, 29 Mar 2011 14:24:36 +0300
Message-ID: <AANLkTin7X=+HK0T0N99KJsHabzvhKxZfSj_+qzCxTeX0@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: update documentation
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Maxin John <maxin.john@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, rdunlap@xenotime.net,
        catalin.marinas@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With some minor modifications, I was able to run kmemleak in MIPS platform.
> Kmemleak output and Patch are available in this link:
>
> https://lkml.org/lkml/2011/3/28/483
>
> Should we include that information in the Documentation ?

Sure, but first lets consolidate the patch for MIPS support.

Daniel.
