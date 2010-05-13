Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab0EMVBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:01:43 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:62524 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab0EMVBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QBlODbNS7EMQl9nPqO4hQUl4rLFzM+1Q6s+EJPcjTNjh15gBietcUeJ5XVKaMaZKMl
         7Nds6umCFOqmwYsA/motFD26tmuO525L6vDWAOXI0xk8XE25DS5kLB5/LHPJ2yUoDx4p
         GrFv+pWxOiBpTaU41z82w5rR5J6+loAKyCfPw=
MIME-Version: 1.0
In-Reply-To: <AANLkTimKHWM46Qci5cF-4VonUkASL_sGFrSwqbzHY2Qe@mail.gmail.com>
References: <0100511104818.8382a7de.akpm@linux-foundation.org>
	 <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk>
	 <AANLkTimglAyS94q0Y3DEx9RROPxus-7l3OfF2_b-zAR3@mail.gmail.com>
	 <AANLkTinmXAAq1HQTb_k3A-bl4uCz1ERhOIHNoCjqzEB4@mail.gmail.com>
	 <89khjo$fd2th6@orsmga002.jf.intel.com>
	 <AANLkTilbqi5crUD8KXmZ5SIv92KioEAN7Ra6nk2ALU6F@mail.gmail.com>
	 <89k83a$87e1b2@azsmga001.ch.intel.com>
	 <AANLkTimKHWM46Qci5cF-4VonUkASL_sGFrSwqbzHY2Qe@mail.gmail.com>
Date: Fri, 14 May 2010 02:31:40 +0530
Message-ID: <AANLkTinaN5RrunHoi6NkO3fcQDkmTB0OqyeI-CnU_DtS@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Record error batch buffers using iomem
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.freedesktop.org,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

On Wed, May 12, 2010 at 8:01 PM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello Chris,
>
> On Wed, May 12, 2010 at 7:20 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Wed, 12 May 2010 18:45:55 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>>> Hello Chris,
>>>
>>> With this patch after XWindows freezes, I get :
>> [snip]
>>> freeze dmesg : http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634_chris_hang.txt
>>>
>>> freeze Xorg.log : http://userweb.kernel.org/~jaswinder/acer_netbook/Xorg_log.txt
>>
>> Jaswinder can you also upload the /sys/kernel/debug/dri/0/i915_error_state
>> following a freeze as well, please. If your /sys/kernel/debug is empty,
>> you will need to "mount -tdebugfs debug /sys/kernel/debug".
>>
>
> i915_error_state :
> http://userweb.kernel.org/~jaswinder/acer_netbook/i915_error_state.txt
>

If you need more information, please let me know.

I am waiting for your feedback.

Thanks,
--
Jaswinder Singh.
