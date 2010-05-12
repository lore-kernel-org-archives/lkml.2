Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0ELObv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:31:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51285 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0ELObu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:31:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=e8Hv6HEHlQ9+aVVNRgJyt34O8ZnkfhpCQ55cjc0Gp62GCD19uZqh3YYnykO3I7K8vn
         Cahnq9FBK6sPUrKl1cCN4VII9Hbr12zjVxmDb/Xtsjvpd0AXCUMJoEr+nqPLRZPthNLq
         H9xEctgFFvBRtorn1VzbVD4MGgQgThNt0oC0I=
MIME-Version: 1.0
In-Reply-To: <89k83a$87e1b2@azsmga001.ch.intel.com>
References: <0100511104818.8382a7de.akpm@linux-foundation.org>
	 <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk>
	 <AANLkTimglAyS94q0Y3DEx9RROPxus-7l3OfF2_b-zAR3@mail.gmail.com>
	 <AANLkTinmXAAq1HQTb_k3A-bl4uCz1ERhOIHNoCjqzEB4@mail.gmail.com>
	 <89khjo$fd2th6@orsmga002.jf.intel.com>
	 <AANLkTilbqi5crUD8KXmZ5SIv92KioEAN7Ra6nk2ALU6F@mail.gmail.com>
	 <89k83a$87e1b2@azsmga001.ch.intel.com>
Date: Wed, 12 May 2010 20:01:48 +0530
Message-ID: <AANLkTimKHWM46Qci5cF-4VonUkASL_sGFrSwqbzHY2Qe@mail.gmail.com>
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

On Wed, May 12, 2010 at 7:20 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 12 May 2010 18:45:55 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>> Hello Chris,
>>
>> With this patch after XWindows freezes, I get :
> [snip]
>> freeze dmesg : http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634_chris_hang.txt
>>
>> freeze Xorg.log : http://userweb.kernel.org/~jaswinder/acer_netbook/Xorg_log.txt
>
> Jaswinder can you also upload the /sys/kernel/debug/dri/0/i915_error_state
> following a freeze as well, please. If your /sys/kernel/debug is empty,
> you will need to "mount -tdebugfs debug /sys/kernel/debug".
>

i915_error_state :
http://userweb.kernel.org/~jaswinder/acer_netbook/i915_error_state.txt

Thanks,
--
Jaswinder Singh.
