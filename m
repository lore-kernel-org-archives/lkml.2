Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1FLTCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 15:02:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34637 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1FLTCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 15:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ffwll.ch; s=google;
        h=mime-version:sender:x-originating-ip:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QWUA4WZc/IIkaRaGIl4ZlxjZSxJbkSnV5LvHn/eTsTbHyxCU98dzqqnhxAx/eVxrMx
         bbSVUZE0pAwjO14Z1Gfz5pq/1j3CgSLdQ+Vwg8GH2H3q6yycsvJK8sY/sJxeHvsPTgyq
         nuS5Mk3PN0blsumUAkkfp5sYIJLf7O4Z+CHl4=
MIME-Version: 1.0
X-Originating-IP: [87.102.216.166]
In-Reply-To: <20110609130431.0c29218a@lxorguk.ukuu.org.uk>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
	<20110608101515.9478.67943.stgit@localhost.localdomain>
	<BANLkTikYtLExBTcYAwicjEH=1bQp28WitQ@mail.gmail.com>
	<20110609091103.4b61f2a1@lxorguk.ukuu.org.uk>
	<1307615814.5963.2.camel@t60prh>
	<BANLkTikvteDhzirKUxDcnD8dykw_00ec=A@mail.gmail.com>
	<20110609130431.0c29218a@lxorguk.ukuu.org.uk>
Date: Sun, 12 Jun 2011 21:02:41 +0200
X-Google-Sender-Auth: RrrzaQhzWksk0iUWNVGwQ2cLoQQ
Message-ID: <BANLkTi=WhtbST=GxP9Q03L0bhppFuozjsw@mail.gmail.com>
Subject: Re: [PATCH 14/15] gma500: nuke the PSB debug stuff
From: Daniel Vetter <daniel@ffwll.ch>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan.

On Thu, Jun 9, 2011 at 14:04, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> The gma500 driver uses a lot of direct Linux services rather than
> disappearing into the weird world of drm_mm and the like so any
> portability is going to be a bit of an illusion at best.

Given that I've mucked around in drm_mm quite a bit I'd be very interested
in your opinion about what's weird in it (and presumably what could be
improved). Can you elaborate?

Thanks a lot, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
