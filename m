Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704Ab1D2Rl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:41:58 -0400
Received: from smtpout01.highway.telekom.at ([195.3.96.112]:13729 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760577Ab1D2Rl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:41:56 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: i915/kms/backlight-combo mode problem (was: Re: Linux 2.6.39-rc5)
Date: Fri, 29 Apr 2011 19:41:53 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201104291758.06975@rk-nord.at> <s5h39l1c7bz.wl%tiwai@suse.de>
In-Reply-To: <s5h39l1c7bz.wl%tiwai@suse.de>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104291941.53663@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takashi Iwai -- Friday 29 April 2011:
> Melchior FRANZ wrote:
> > The bug was introduced with commit ba3820ade317ee36e496b9b40d2ec3987dd4aef0
> > [...] when using KMS my notebook's[2] screen remains dark, because the
> > backlight isn't turned on.

> Could you check whether the patch below changes the behavior?
> If this cures, it means that the backlight-combo mode doesn't work on
> your machine.

Yes, that works. (Test was with fafc9929c668f8bae6dd1f109f33a86d2cb3c460,
which is current HEAD.)

m.
