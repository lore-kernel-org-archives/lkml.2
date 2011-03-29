Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1C2OWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:22:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49919 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1C2OWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:22:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=m0uuCeL+3Wq0dz2ZMbpZMXx7v0gWyhBRX/MSENtWRN3LC/80BZozcNAYqrUWe+GCVI
         ZUuzEZ2QW6zDZPnD1A1rUPz37bfSkSfJivIW+Aq1EDnrgIn1gPXohqQ1hQEz28pv72sR
         H28VHrQJiK0JsBcaLhYQqL1cQ4/i2V4sGy6ug=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Adq8i_qoiHhLB9K-CkUbT8uHZeg-H8Z3_Kgrw@mail.gmail.com>
References: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<1301401385-8935-1-git-send-email-chris@chris-wilson.co.uk>
	<AANLkTin0bicOYyY2WCaBxN276t5RV-Q9UZVr=WQ6NmQe@mail.gmail.com>
	<1bdc18$k1kc9s@fmsmga002.fm.intel.com>
	<AANLkTi=Adq8i_qoiHhLB9K-CkUbT8uHZeg-H8Z3_Kgrw@mail.gmail.com>
Date: Tue, 29 Mar 2011 17:22:13 +0300
X-Google-Sender-Auth: mBciq6wbdr7-BrpaHx3K4mxBqT0
Message-ID: <AANLkTi=ejDZYxyHYWXZiLXG+L1o8BqvQp8CQVhsUf570@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Move the irq wait queue initialisation into the
 ring init
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 4:39 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Tue, Mar 29, 2011 at 4:22 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Tue, 29 Mar 2011 16:05:35 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>>> On Tue, Mar 29, 2011 at 3:23 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>> > Required so that we don't obliterate the queue if initialising the
>>> > rings after the global IRQ handler is installed.
>>> >
>>> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>>
>>> I applied both of the patches on top of yesterdays git HEAD and I just
>>> get a blank screen after GRUB. No serial or net console here. Do you
>>> want me to try just one of the patches or turn on some debugging
>>> options?
>>
>> That was the unspoken side-effect: if we fail to load the i915 module after
>> disabling the outputs, then we would be left with a blank screen.
>>
>> If you can ssh in and retrieve the dmesg, then it should at least give a
>> reason...
>
> I have
>
> CONFIG_DRM_I915=y
>
> so there are no modules involved. I'll see if I can ssh to the box.

No ssh - the box seems to be dead.
