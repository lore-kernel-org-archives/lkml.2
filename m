Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1DEPfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:35:23 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51393 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab1DEPfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=s5EGAoeEPJOAKS9zs535fPWWsH5pUEXkK72cb2ntHPFag9D8BhThe1o4awQc54a5Vb
         hIgVYahYolvdLb0tz28NcqQO0pu+VLiboDXUSQWrWSFpQFzLiJJJw9YKVp9qeYzH6Dy8
         ARc0sRYplJ9yjePmX0omVb8lEOgg0KfBEt6D4=
MIME-Version: 1.0
In-Reply-To: <1bdc18$k458om@fmsmga002.fm.intel.com>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
	<1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<20110401114429.GA3526@viiv.ffwll.ch>
	<AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com>
	<BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com>
	<b7da2f$qvoau5@fmsmga001.fm.intel.com>
	<BANLkTinXZVOy9-j4TiJ7HMcTvv9Q8RS+DA@mail.gmail.com>
	<1bdc18$k458om@fmsmga002.fm.intel.com>
Date: Tue, 5 Apr 2011 18:35:17 +0300
X-Google-Sender-Auth: EuLN1azc8BH4-qp0T3VC-4jYPIE
Message-ID: <BANLkTin12LW3WfnTAOFYCxAesk8hQRPgYA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before
 KMS takeover
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>, Tomas Winkler <tomasw@gmail.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 07:42:14 -0700, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> NO.

On Tue, Apr 5, 2011 at 6:12 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> And you seemed to have missed that patch has sat around waiting for Pekka
> to give me some information on the failure on his machine.

No, it wasn't. I told you I wasn't able to capture anything useful and
that 2.6.38 didn't have the problem.

On Tue, Apr 5, 2011 at 6:12 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> I was being facetious in order to get a response. Thanks for playing,

I am happy to test patches but I don't appreciate being blackmailed
into debugging your shit.

                         Pekka
