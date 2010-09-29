Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab0I2A5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:57:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35246 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab0I2A5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UdYs9ykBubOMBCjB4BRo4ofLC8g78XrU2hr4rOh5VlgkMBoFT3HyrqDkEKhKdN5JHu
         +fkSeWbLrXFmTLyKlryLL8lkGOym/0kvg1glXigy6sO17bwa++AYksblGJ50m+rHOE03
         UCTzNmMLpb8kzOjjpAXOPWfjccG0FqxoIUtus=
MIME-Version: 1.0
In-Reply-To: <89k77n$p2kgat@fmsmga001.fm.intel.com>
References: <AANLkTi=dqiY+kxfW4k+ke6M5J45WbM8j2Vi=y9VxYOY0@mail.gmail.com>
	<89k77n$p2kgat@fmsmga001.fm.intel.com>
Date: Wed, 29 Sep 2010 08:57:29 +0800
Message-ID: <AANLkTima2Rc=b199oL_f0375kXtnimgn-Laq=7QU+xy9@mail.gmail.com>
Subject: Re: drivers/gpu/drm/i915/i915_suspend.c:792: error: const struct
 intel_device_info has no member named gen
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 9:46 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, 28 Sep 2010 21:36:09 +0800, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>   CC      drivers/gpu/drm/i915/i915_suspend.o
>> drivers/gpu/drm/i915/i915_suspend.c: In function 'i915_save_state':
>> drivers/gpu/drm/i915/i915_suspend.c:792: error: 'const struct
>> intel_device_info' has no member named 'gen'
>> drivers/gpu/drm/i915/i915_suspend.c: In function 'i915_restore_state':
>> drivers/gpu/drm/i915/i915_suspend.c:827: error: 'const struct
>> intel_device_info' has no member named 'gen'
>> make[4]: *** [drivers/gpu/drm/i915/i915_suspend.o] Error 1
>> make[3]: *** [drivers/gpu/drm/i915] Error 2
>> make[2]: *** [drivers/gpu/drm] Error 2
>> make[1]: *** [drivers/gpu] Error 2
>> make: *** [drivers] Error 2
>
> Which tree are you compiling? As it is missing:
>
> commit c96c3a8cb7fadcb33d9a5ebe35fcee8b7d0a7946
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Wed Aug 11 09:59:24 2010 +0100
>
>    drm/i915: Include a generation number in the device info
>
>    To simplify the IS_GEN[234] macros and to enable switching.

Chris,

I must have done something wrong. I rebuild from scratch and now it's ok.

Thanks,
Jeff
