Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab1CXGyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:54:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60829 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab1CXGyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=kO0InH7ko5T+hN3L/oWuHyd/mWkuay1YiEJ+pIo2FN5TViD/lxfAU/zo4piCB2493b
         3OtrJ7savRnu2NqSMQaX2/yZ/YuiqF03K3dqMACRkW7n3fLjqsWEgyUnFFNn6TgvWCN+
         8DhiRq1TG9tMWVWZQqb/vZIk8cDCb5M9RICU8=
MIME-Version: 1.0
In-Reply-To: <20101115084442.3ad2c6f9@jbarnes-desktop>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com>
 <20101115154820.GB21734@srcf.ucam.org> <20101115084442.3ad2c6f9@jbarnes-desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 24 Mar 2011 02:53:53 -0400
Message-ID: <AANLkTinX+GjJG0oSMpDCz3Y-2gLToOUb-kwyhPn=rUKW@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] Backlight: Add backlight type
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, Richard Purdie <rpurdie@rpsys.net>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:44, Jesse Barnes wrote:
> On Mon, 15 Nov 2010 15:48:20 +0000 Matthew Garrett wrote:
>> Richard, any feedback on this?
>>
>
> At KS akpm said he'd likely be taking over backlight from Richard,
> since Richard is very distracted with other things atm (please correct
> me if I'm wrong).
>
> So either someone needs to volunteer to maintain this subsystem (I know
> how much you love backlights, maybe you'd like to do it?) or you need to
> get this patch over to akpm.

this go anywhere ?
-mike
