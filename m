Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1FUQwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:52:10 -0400
Received: from smtpout04.highway.telekom.at ([195.3.96.117]:14636 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751237Ab1FUQwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:52:08 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0-rc4
Date: Tue, 21 Jun 2011 18:52:01 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39.1; KDE/4.6.4; x86_64; ; )
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
References: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com> <20110621150544.GA2717@elliptictech.com>
In-Reply-To: <20110621150544.GA2717@elliptictech.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106211852.02120@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Bowler -- Tuesday 21 June 2011:
> We're at -rc4 now, but it seems that the following patch (drm/i915: add
> missing intel_enable_plane() call to i9xx_crtc_mode_set()) has not made
> it in yet?
> 
>   http://permalink.gmane.org/gmane.linux.kernel/1148279
> 
> The i915 driver has been broken since 3.0-rc1 without this fix,
> which has been available for 3 weeks now.

Keith has suggested a better fix (https://lkml.org/lkml/2011/6/6/560),
but for some reason it still hasn't made it into the kernel.

m.
