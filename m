Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab1AKOsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:48:02 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33406 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab1AKOsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:48:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EsTECssbGTmgrzTr/crWInS2nREDPXrArX5RCWZqOxT94pqSutbC1HehD12oCa8mZt
         NgPaxfvRArSGHzBA7o7rVn3ZNZNr+T8P/c36bWbRwD2mgwxnm0ph85VpNyQjASZAsHzz
         fts9tPPrksla6OMho1n1oLwywYsy9SqpxFOOA=
MIME-Version: 1.0
In-Reply-To: <20110111133320.GB10705@atrey.karlin.mff.cuni.cz>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
	<20110106104816.GA4026@tiehlicka.suse.cz>
	<20110111133320.GB10705@atrey.karlin.mff.cuni.cz>
Date: Tue, 11 Jan 2011 15:47:59 +0100
Message-ID: <AANLkTinU2XqyQJGu-Hmhafa37J_wgGEpMJwUGQQNoNaO@mail.gmail.com>
Subject: Re: Linux 2.6.37
From: Alex Riesen <raa.lkml@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 14:33, Pavel Machek <pavel@ucw.cz> wrote:
>> I can reproduce the problem easily by:
>> xset dpms force standby; sleep 3s; xset dpms force on
>
> (You are using "vesa" or "fbcon" X11 driver, right? I seen same problem
> until I switched to "intel" X11 driver).

No, the "intel".
