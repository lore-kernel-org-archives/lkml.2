Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182Ab2FHXi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 19:38:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48954 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761856Ab2FHXiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 19:38:11 -0400
MIME-Version: 1.0
In-Reply-To: <1339196027_596874@CP5-2952>
References: <alpine.DEB.2.00.1206080952010.15272@skynet.skynet.ie>
 <CA+55aFyASr5Jfok7vVKXg9=n_pBGyjLZf3MmRik90y8qXRNo3g@mail.gmail.com>
 <1339193608_596134@CP5-2952> <CA+55aFxQn_KJcHztPyUptOb=s-+n5-4mDs+dGL1XiN4QbAv2mg@mail.gmail.com>
 <1339196027_596874@CP5-2952>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Jun 2012 16:37:49 -0700
X-Google-Sender-Auth: _QzpA6EWLpMXYspNzpt2so1uvJ8
Message-ID: <CA+55aFx7vAePGw7TGkXT34CohaJ5C+1kmUoQVE9h1Ek4U_Jdrg@mail.gmail.com>
Subject: Re: [git pull] drm intel + exynos fixes
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 3:52 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> And that was my point. You were blaming the patch for making you aware
> of existing behaviour that results in utter confusion, for as Alex
> points out there is no sane way for userspace to handle the unknown
> connection status from the detection routine.

Ahh. Yes, then I agree with you. The current behavior is clearly
insane in the presense of an unknown connector status.

So if the higher levels are eventually fixed to say "if one input is
'unknown' and another is 'connected', we'll assume 'unknown' means
'not connected'", then we can re-apply that patch.

As it is, it's apparently a disaster to reply 'unknown' in this situation.

                Linus
