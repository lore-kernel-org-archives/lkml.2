Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935879Ab1JFXC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:02:27 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:31126 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758965Ab1JFXC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:02:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EADgzjk5MCqWq/2dsb2JhbABCmUSOc4EGgVMBAQU4HgYcARALCw0JFg8JAwIBAgERFh4GDQEFAgKvGIdMPYh0hywEiX+Jb40ehEQ
X-IronPort-AV: E=Sophos;i="4.68,499,1312171200"; 
   d="scan'208";a="140203133"
Message-ID: <4E8E337D.9010907@gmail.com>
Date: Thu, 06 Oct 2011 19:02:21 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110928 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PULL] drm-intel-fixes (drm/i915 driver)
References: <yunpqiikeut.fsf@aiko.keithp.com> <CA+55aFzR91rOstOcAUoTXGHvztqG-aB-j37_p3F9C3-Ngc_6dQ@mail.gmail.com> <yunlisxltn1.fsf@aiko.keithp.com>
In-Reply-To: <yunlisxltn1.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard wrote:
> On Thu, 6 Oct 2011 10:12:57 -0700, Linus Torvalds<torvalds@linux-foundation.org>  wrote:
>
>>    [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
> Thanks. I've got a patch series that fixes a pile of refclk bugs which
> is still out for review that should fix this. This error should be
> harmless, but still..
>
And what about blanking (black screen) issue reported Sep21?
I confirm that disabling the blanking e.g. commenting out
/* intel_panel_set_backlight(dev, 0); */
in intel_panel.c is somehow working on EeePC as well as Dell machine.

I guess Linus has stopped using EeePCs ;-)

Woody

