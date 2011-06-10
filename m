Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab1FJRoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:44:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34130 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJRoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dV1wKVyOcxIq9/x+s2Srm6mREf1Bt+ah8kKhVtrKaTeFwtZPh2raVTmUtTYiUo87by
         gkRpThbAXZ+yopyutMLD8BpT5Cll7nPZgYei3V5ZXf8HDnwsw7w2PopJbOYbTEimf9zM
         lnHLY7DbqMICaVG8PjYFJoXyozoZQrS/5A6Ko=
MIME-Version: 1.0
In-Reply-To: <20110610172734.GI26441@sirena.org.uk>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de> <20110610172734.GI26441@sirena.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 10 Jun 2011 13:44:00 -0400
Message-ID: <BANLkTimN0-a++2Nd13rHGSwkVPDxU8GBhQ@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: Add ADAU1701 codec driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        uclinux-dist-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 13:27, Mark Brown wrote:
> Also someone should remonstrate with the hardware designers.

if there's things we can take back, i can forward them along.  the
last conversation i had with them sounded like they have no problem
accepting feedback.
-mike
