Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab1D2UJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:09:59 -0400
Received: from smtpout04.highway.telekom.at ([195.3.96.117]:5435 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751061Ab1D2UJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:09:58 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: i915/kms/backlight-combo mode problem (was: Re: Linux 2.6.39-rc5)
Date: Fri, 29 Apr 2011 22:09:54 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201104291941.53663@rk-nord.at> <s5hwricc021.wl%tiwai@suse.de>
In-Reply-To: <s5hwricc021.wl%tiwai@suse.de>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104292209.55154@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takashi Iwai -- Friday 29 April 2011:
[https://bugzilla.kernel.org/show_bug.cgi?id=31522]
> Looking at bugzilla, the problem seems like the case lbpc=0.
> What about the patch below instead?

> -			val *= lbpc;
> +			if (lbpc)
> +				val *= lbpc;

Yes, that works as well. (I had assumed that this was the problem,
but wasn't sure if a zero was even a legitimate value, or rather
a sign for a problem or wrong assumption elsewhere.)

m.
