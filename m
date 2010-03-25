Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0CYGxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 02:53:01 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46076 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0CYGxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 02:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tP98Ex1gw8LfBtksbnsz3D9i+ej2/s3slSAPLHtpTyE12YvosP2TK0c/L6T1dJB55s
         KMsyqBCVx/Rzt88KUjbu1HBkCw4bEG4JSyxBRgAMR3bKC3S9gkuY/qJ1MuLTJKwf+HJA
         2vqhJyzO7EUPXiVlJykwOI2UVo0hw9nbEqdWk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1003250331460.5810@skynet.skynet.ie>
References: <alpine.DEB.2.00.1003250331460.5810@skynet.skynet.ie>
Date: Thu, 25 Mar 2010 08:52:58 +0200
X-Google-Sender-Auth: 36d61b4216a0e3cd
Message-ID: <84144f021003242352g427ed93ay29e1c4b7e43b75cc@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

2010/3/25 Dave Airlie <airlied@linux.ie>:
> Some nouveau updates + misc drm core fixes,
>
> radeon kms: mostly fixes, however a cleanup to the ugly asic tables to
> avoid drift between C prototypes moves some stuff around, and I've merged
> Jerome's GPU recovery code, as I'd much rather users had some of hope of
> recovering from their GPU locking up than a dead box. It seems to work
> for quite a lot of people that have tested it, and it won't make a GPU
> lockup problem worse. This also finally fixes HDMI audio on rv7xx cards.

Are there any i915 fixes pending? I tried 2.6.34-rc2 few days ago and
all I got was a blank screen at start up. The driver is pretty busted
for 2.6.33 also, I'm getting random screen corruption and the
occasional blank screen (which is "fixed" by suspend/resume).

I'm unfortunately busy with working on something else so I don't have
time right now to debug the thing. Just wanted to know if you're aware
of the quality problems with i915 and if there are any fixes pending.

                                   Pekka
