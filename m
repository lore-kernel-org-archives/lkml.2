Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab1D0Lvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:51:39 -0400
Received: from smtp7.mail.ru ([94.100.176.52]:59198 "EHLO smtp7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab1D0Lvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:51:37 -0400
Date: Wed, 27 Apr 2011 15:51:33 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Alan Ott <alan@signal11.us>, Steve Sakoman <sakoman@gmail.com>,
        Steve Calfee <stevecalfee@gmail.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Regression?] Removed regulator support in ehci-omap
Message-ID: <20110427115133.GA16447@rainbow>
References: <20110411093214.GA18215@rainbow>
 <4DA3350E.2060400@gmail.com>
 <BANLkTinDMZ+CyGCmzZu8cSz1L_yFXxm+vg@mail.gmail.com>
 <112ef82aebc719ef25cde126f2014ebc@mail.gmail.com>
 <20110412040420.GB25239@rainbow>
 <bcd954a468e6a07bd673b7d0731e9344@mail.gmail.com>
 <4DB0D58E.4030508@signal11.us>
 <8712165194c49f0b4d8c1bd1fe717b8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8712165194c49f0b4d8c1bd1fe717b8a@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:07 Sun 24 Apr     , Keshava Munegowda wrote:
> I have posted the patches on April 22, 2011.
> If possible I request you to test this.

Hi, Keshava!

Sorry for delay - it took some time to find _where_ exactly you have posted
the patch (thanks to Alan for giving the link). Anyway, it[1] seems to work
as advertised (I also applied GPIO polarity fix [2] and board file patch[3],
all on top of 2.6.39-rc4) - at least stuff in /sys/class/regulator looks right,
and USB devices are detected. There's probably something still missing in the
board file, as USB detection starts to work only if I booted TI's kernel
(that came with board) before trying patched 2.6.39-rc4, but I hope that
this isn't connected to this regulators issue.

[1] http://www.spinics.net/lists/linux-usb/msg45618.html
[2] https://lkml.org/lkml/2011/4/14/45
[3] http://arago-project.org/git/projects/?p=linux-omap3.git;a=commitdiff;h=2ec611981ad76256d5034ae36708d807142bed1c

-- 
Best regards,
Dmitry "MAD" Artamonow

