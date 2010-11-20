Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0KTBNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:13:21 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57985 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0KTBNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:13:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DuMsAE4qhaXMa+1dd+jw5h4K1XTKtZtwIajD4+NOqNWZ0WwCYVuiW0LWBbSKAND7AD
         JD3zkdtkBRlcrNvqVltPDs8cXYhh3K/gf9rVWFYA3qLLNO1ZQFIX9+hOJii7qbzJokpo
         axEkFb23FotpNtiotYYxfotZoqyi/Iuy6hoxw=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.61.1011190750500.8468@mayday.local>
References: <Pine.LNX.4.61.1011190750500.8468@mayday.local>
Date: Sat, 20 Nov 2010 02:13:13 +0100
Message-ID: <AANLkTinF7BtYJwowfke+q0qjaXUc19EYRioAORU7YSAd@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups ... ps
 jaxk sid ... You are using the wrong number.
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Robert de Bath <robert$@debath.co.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/19 Robert de Bath <robert$@debath.co.uk>:

> Using the SID solves the "all GUI programs are in the same group" problem
> but still keeps "make -j99" in one group and different [a-z]terms in
> different groups. What's more setsid(1) and setsid(2) make userspace
> control really easy.

I grouped all the processes on my system but a few into per-session
control groups by a quick python hack into CGFreak. It looks very
funny atleast, I never spawned so many groups before:
http://www.df.lth.se/~triad/sidgroups/

The big circle in the middle shows the cgroups alottment, the
satellites show the processes inside each cgroup. The number
on the perimeter is the SID.

Yours,
Linus Walleij
