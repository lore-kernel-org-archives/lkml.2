Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1BNMYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:24:21 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37289 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1BNMYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:24:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=PnMQROuN3tRT81lxOMa1Ky6ZCQuhJsnWreTm5rvR23QtGk4YeDiKC5V24Oc+SuN73G
         P39dwQdOp+wkDw7Xewhp6VjYSMc5gLR1ktxIQ3u13gLz9QK3x5yB4I0VI5kAKiJCPlI5
         gYHBE+WBkqdGOTSqoBt8lFIIeGUlkf20c28Cs=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTimM1Tmws46DUyoNGsn+P8WN1XPsRu=L8yPzd=xU@mail.gmail.com>
References: <AANLkTimM1Tmws46DUyoNGsn+P8WN1XPsRu=L8yPzd=xU@mail.gmail.com>
Date: Mon, 14 Feb 2011 13:24:16 +0100
Message-ID: <AANLkTikO=5zBCvPbd2MXqgzE_mvnabTtH_e2C5_5bpQv@mail.gmail.com>
Subject: Re: [next-20110214] Kernel-modules with unknown parameter
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, DRI <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 1:13 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> I have pulled Dave's drm-fixes-staging into today's linux-next and did
> not see a KMS-modesetted resolution change in VT (runlevel-3).
> After a quick check of my dmesg, I see also my kernel-module for sound
> has "unknown parameter".
> ( Thus, personally I don't think it is a bug from any drm-2.6 tree. )
>
> # dmesg | egrep -i 'unknown|param'
> [   12.431216] radeon: Unknown parameter `modeset'
> [   12.665911] snd_intel8x0m: Unknown parameter `index'
> [   37.311333] radeon: Unknown parameter `modeset'
>
> Any idea what's going on? Stephen, Randy noticed the same like me?
>
> Regards,
> - Sedat -
>
> P.S.: Attached are dmesg and kernel dot-config.
>

[ CC Dmitry Torokhov ]

Could that be a possible fix for me [1]?

- Sedat -

[1] https://patchwork.kernel.org/patch/548891/
