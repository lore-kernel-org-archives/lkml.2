Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1DEKhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 06:37:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65235 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1DEKhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 06:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bB3Kicr+sy3Ch3ppD1+X7vJSV+2rYlhaRLurRqeGr5fG9EhQ4urVr/AUt6BS3GzRow
         lAHXwMo4ELgLV01wG8tgnCQyYPOqPigkm7MliqNAsRagO24PHamaf46NUXlpYHKXT5Jt
         ZUkSxsWDYAQXdpk6O493v/GrEI42/LhzwGU8Y=
MIME-Version: 1.0
In-Reply-To: <b7da2f$qvoau5@fmsmga001.fm.intel.com>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
	<1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<20110401114429.GA3526@viiv.ffwll.ch>
	<AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com>
	<BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com>
	<b7da2f$qvoau5@fmsmga001.fm.intel.com>
Date: Tue, 5 Apr 2011 13:37:17 +0300
X-Google-Sender-Auth: ZyRjrzES7MJRWghKWgYeY64Zobg
Message-ID: <BANLkTi=kXod21RUukrTuMzP5TFqgo4NxRw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before
 KMS takeover
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tomas Winkler <tomasw@gmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris!

On Tue, Apr 5, 2011 at 1:30 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, 5 Apr 2011 13:21:08 +0300, Tomas Winkler <tomasw@gmail.com> wrote:
>> On Fri, Apr 1, 2011 at 2:51 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> > Unfortunately I get a blank screen with after boot:
>> > Nacked-by: Pekka Enberg <penberg@kernel.org>
>
> But until you can tell me where it explodes on your system, we fix
> issues on several other machines...

Oh, that's nice, you first made the damn thing flicker in 2.6.39-rc1
and now you're fixing it for others by giving me a blank screen after
boot?

I guess I don't need to tell you that I am not at all happy especially
since you keep breaking i915 in almost every damn release!

>> Not sure this is related, but when I enable DRM_I915_KMS=y I'm got
>> stuck after boot too. When KMS is disabled I can at least get to the
>> console (no graphics)
>> This is with kernel 2.6.39-rc1.  It worked fine with 2.6.38. I don't
>> have much time bisect and reboot.  Shell I  try to pull drm-fixes for
>> rc2 or use try this patch?
>
> Add drm.debug=0xe to your grub kernel parameters and attach the dmesg for
> the failing boot. From that I should be able to recommend a course of
> action.

OK, I'll try that tonight.

                       Pekka
