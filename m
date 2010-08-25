Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0HYTSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:18:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44180 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0HYTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=o9WFb+37XzdDT8cy9cUsg58li9ysCkqWyz7x4l+XeG3ibSNbFG1O+1urbcD0hBI0We
         1/jL3qYtTJYOJJcA/9uD0RchtiTD0QQ5WTC8QiyjQb6p6sp1jztZBAVCnUAjmb6V0AYj
         p/mZkpI8zcUVgXs9hvvFvaHXDksYXdSSR+q6Y=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602F0FA3D20@dlee06.ent.ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
	<1277943660-4112-2-git-send-email-x0095840@ti.com>
	<1277943660-4112-3-git-send-email-x0095840@ti.com>
	<1277943660-4112-4-git-send-email-x0095840@ti.com>
	<1277943660-4112-5-git-send-email-x0095840@ti.com>
	<1277943660-4112-6-git-send-email-x0095840@ti.com>
	<1277943660-4112-7-git-send-email-x0095840@ti.com>
	<1277943660-4112-8-git-send-email-x0095840@ti.com>
	<1277943660-4112-9-git-send-email-x0095840@ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD34D5@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3ADE@dlee06.ent.ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD39F6@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3BB2@dlee06.ent.ti.com>
	<AANLkTimENxUjUWJQSZ1dmdkX_9hQ0pjat-kyR9oNjVxf@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3883@dlee06.ent.ti.com>
	<AANLkTi=NuPu6bvv6KF7sXRp02bvfz7oRkG1SG1PstA-H@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA397F@dlee06.ent.ti.com>
	<AANLkTinaJ=xn_CAJznVtMcA0nwK_-gbo05OQKM7PuoYA@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3995@dlee06.ent.ti.com>
	<AANLkTinjMujus-28DcLzZ+16GAGpLohwhPhuTi5uKhB8@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA39BA@dlee06.ent.ti.com>
	<AANLkTikQCTtwOkAmt3PZrOkxi=VzJtfNKGsH=YXawt9t@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3AED@dlee06.ent.ti.com>
	<AANLkTi=4YYvyHdL=F_FYQ4e5v-+K3RMZFngdfuKPQ-4L@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3D20@dlee06.ent.ti.com>
Date: Wed, 25 Aug 2010 22:18:17 +0300
Message-ID: <AANLkTi=VRROWWZ4x-znXshz9KWNZAaizVFt=M92D3ByW@mail.gmail.com>
Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 7:00 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
>> Or the whole iovmm.c can be copied and just remove the mapping.
>
> That is the migration patches do, remove custom bridge mapping and
> use iovmm module instead.

You didn't get me; copy the iovmm.c code into dmm.c, and remove the mapping.

-- 
Felipe Contreras
