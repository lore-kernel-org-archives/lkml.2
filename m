Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1EUTeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:34:05 -0400
Received: from zinan.dashjr.org ([173.242.112.54]:39070 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1EUTeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:34:04 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: Major 2.6.38 regression ignored?
Date: Sat, 21 May 2011 15:33:46 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.2; x86_64; ; )
Cc: Ray Lee <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, perex@perex.cz,
        alsa-devel@alsa-project.org
References: <201105201306.31204.luke@dashjr.org> <201105211123.56053.luke@dashjr.org> <aefc95$1usaq@orsmga001.jf.intel.com>
In-Reply-To: <aefc95$1usaq@orsmga001.jf.intel.com>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211533.49082.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 21, 2011 11:40:17 AM Chris Wilson wrote:
> The bisection is into an old DRI1 bug on 945GM. That DRI has inadequate
> locking between release and IRQ and so is prone to such races as befell
> Kirill should not surprise anyone. As neither UMS nor DRI supported SNB,
> I can quite confidently state they are separate bugs.

Unfortunately, I cannot help troubleshoot that bug any further, as I no longer 
have the affected motherboard. I was unable to reproduce it on my Intel 
DQ67SW.

However, I did encounter a new regression, which I have reported as:
	https://bugzilla.kernel.org/show_bug.cgi?id=35552
This one is related to Intel HD Audio, not Graphics.
