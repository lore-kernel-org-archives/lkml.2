Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1DALvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:51:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55571 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1DALvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=d1B//8bo6TpvCAoBCJspUBs+El9zhgAuwIr1Frkg0GAAuqPn8+XLezyKmpzenrKcT2
         cbvBTui/zmdyfFnkdaN+e4H3o7UTXWug6T9y/1nVZBBjMrgzhsedofKk86RCOP1GfRtF
         PBMUpt/awfCqlN+Ga6FCODqa+KHlegDhzlkF0=
MIME-Version: 1.0
In-Reply-To: <20110401114429.GA3526@viiv.ffwll.ch>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
	<1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<20110401114429.GA3526@viiv.ffwll.ch>
Date: Fri, 1 Apr 2011 14:51:42 +0300
X-Google-Sender-Auth: J1RSWjlcCo4frwVf0NmMd9Wr5wE
Message-ID: <AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before
 KMS takeover
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 2:44 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Mar 29, 2011 at 11:46:29AM +0100, Chris Wilson wrote:
>> If the outputs are active and continuing to access the GATT when we
>> teardown the PTEs, then there is a potential for us to hang the GPU.
>> The hang tends to be a PGTBL_ER with either an invalid host access or
>> an invalid display plane fetch.
>
> This patch seems to fix resume flakiness (that recently developed
> complete reliability in hanging the gpu) on my i855gm. Captured
> error_states look as described here. Latest -staging merged into latest
> -linus is now again fully reliable at s/r.
>
> Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Unfortunately I get a blank screen with after boot:

Nacked-by: Pekka Enberg <penberg@kernel.org>
