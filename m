Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1BHBkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:40:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51641 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1BHBkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:40:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FMvxIRIc8vZZHuB/uraiyAs9cMlVG10G5zhfhTNwAtKjQ3GqDjBNI/9oF+mA3jyRbE
         VXw0G47KMy8Q/jMkaeBwZwtX3uPjiK3Xv+TcI38qTUBsln2/WigMVaA/n23WW0Qos5+2
         IZC7cm3v0Ink9VbGFTwvDQy92IbKubF9dHE34=
MIME-Version: 1.0
In-Reply-To: <201102072220.30706.rjw@sisk.pl>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
	<AANLkTinv=pfArgT4VFCUeY_bKb4q3KSREvU+L8V5k0G9@mail.gmail.com>
	<AANLkTim2czZfsbGaG=K-=dV5hENgUOUhjBpWoa+mTjyb@mail.gmail.com>
	<201102072220.30706.rjw@sisk.pl>
Date: Tue, 8 Feb 2011 09:40:34 +0800
Message-ID: <AANLkTim5EuRqfcQ44_G=gmGaD2v4oEXH4Go9Lm4wV2uW@mail.gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Takashi Iwai <tiwai@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 5:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, February 07, 2011, Jeff Chua wrote:
>> Same issue encountered even after a fresh build.
>
> So, can you confirm that on your machine the issue is 100% reproducible and
> it goes away after reverting
>
> commit 5d1d0cc87fc0887921993ea0742932e0c8adeda0
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Mon Jan 24 15:02:15 2011 +0000
>
>    drm/i915: Reset crtc after resume

100% confirmed that it works after reverting.

Jeff.
