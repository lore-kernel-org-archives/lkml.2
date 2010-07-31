Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0GaHEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 03:04:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53738 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab0GaHEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 03:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=l98/fn2lTuRqaAZtYSRpzkSockL0WbvLuPK9giveqyQghKpkEMASyky2Y4q+uDVHX3
         aZbiOkr/6of1RXchmhlOQh/cqpTTrHS5qbUTwc68q2JqrcB+lgnD+vOKXxTjLrA3OjUM
         +RyjxQhT3fF7g+x/u3lAVYBbL9JcyZ3Cx0ISg=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Input: Make ADS7846 independent on regulator
Date: Sat, 31 Jul 2010 09:03:52 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, vapier@gentoo.org, pavel@ucw.cz,
        akpm@linux-foundation.org, khilman@deeprootsystems.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.y.miao@gmail.com
References: <1280555108-27994-1-git-send-email-marek.vasut@gmail.com> <20100731063329.GA23620@core.coreip.homeip.net>
In-Reply-To: <20100731063329.GA23620@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007310903.52921.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne So 31. července 2010 08:33:29 Dmitry Torokhov napsal(a):
> Hi Marek,
> 
> On Sat, Jul 31, 2010 at 07:45:08AM +0200, Marek Vasut wrote:
> > In case regulator was not found, ADS7846 failed to probe.
> > 
> > This fixes a problem on some Sharp Zaurus devices, where there is no
> > regulator present and yet the touchscreen is used.
> 
> Too many ifdefs to my taste... Can we have ads7846_regulator_enable()
> and friends stubbed out in case !CONFIG_REGULATOR?

Hi,

I believe you should ask the regulator guys about these. We can certainly just 
remove the ifdefs (I was thinking about it, because it poluted the code quality 
quite a bit). Just removing the ifdefs shouldn't cause any harm.

Cheers
