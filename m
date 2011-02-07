Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1BGOLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:11:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40428 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1BGOLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:11:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q9Y/JgHQjXyarPsKrfDhSEqGS1RRb1xrPFlUbzxajo0LUNwEA+s0yWF2o/2sTvEsIp
         F+lPJUEHt0tcHDTYedcX3h/hyXMbafCqqqB3vIEFYFeLMPsVde3ch/lGGo6m7Fm5DyLQ
         yGmtRhj/NdZGBTBp5RubtbIM9t/Il65T920g8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinv=pfArgT4VFCUeY_bKb4q3KSREvU+L8V5k0G9@mail.gmail.com>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
	<s5hfws1whq8.wl%tiwai@suse.de>
	<AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
	<AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
	<849307$bf0dak@azsmga001.ch.intel.com>
	<AANLkTi=Z1fCA1N47YaCh1tn=PCAAboWtNCUyUH-N3yUo@mail.gmail.com>
	<AANLkTik0eJVr1S5=bCO8kmkwCxYzLE_kh9C3ccpn+mWX@mail.gmail.com>
	<s5hy65suu7t.wl%tiwai@suse.de>
	<AANLkTi=KGMJ9vLaLfkzGQrc-F2eB5CRmDX1L5UohPTZ=@mail.gmail.com>
	<s5htyggusyg.wl%tiwai@suse.de>
	<s5htyggi21m.wl%tiwai@suse.de>
	<AANLkTinv=pfArgT4VFCUeY_bKb4q3KSREvU+L8V5k0G9@mail.gmail.com>
Date: Mon, 7 Feb 2011 22:11:29 +0800
Message-ID: <AANLkTim2czZfsbGaG=K-=dV5hENgUOUhjBpWoa+mTjyb@mail.gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 9:38 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Mon, Feb 7, 2011 at 6:15 PM, Takashi Iwai <tiwai@suse.de> wrote:
>>> Thanks, that looks good.  What about other files?  Did you change
>>> (especially intel_drv.h) from Linus git tree?
>
> I will try again  from a fresh build tonight.
>
>>> I'll also check later to be sure (now I have no machine for testing).
>> I don't see any problem with my machine (but running in 32bit).
>>
>> Are you sure that you are seeing the same CRTC?  There are two active
>> CRTCs on Intel, and both are initialized and set up.
>
> I don't know about that. Even when I attempt to just the pointer
> directly as in "static void intel_crtc_reset(struct intel_crtc
> *intel_crtc)", it ended up getting a different value. Strange.
>
> intel_crtc ffff880239aa5800
> intel_crtc ffff880239aa5000
>
>
> I'm building everything fresh now.

Same issue encountered even after a fresh build.

Jeff
