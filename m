Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab1BRWOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:14:49 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49920 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab1BRWOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:14:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PbTu5RgrhXnxUYT/2lkxHDQYQct7+SaH1GCgM7ViAAFyFJMwdu5gBzWLOvmb5Aaozk
         KZ6FZtLszqesuPA/Q4iynCvhLLMVkTURFMBFuRxkkOT0B1+zVGYC6fod6curs0iI6f+m
         Z1VkZJMl2PKISCdAMDN8RxWL7OgnJyAjzSNWw=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=6efAdh76uO5Qeq8FiRWOFQW-MBUWJWxzT1rhf@mail.gmail.com>
References: <alpine.DEB.2.00.1102172249020.5315@skynet.skynet.ie>
	<AANLkTi=6efAdh76uO5Qeq8FiRWOFQW-MBUWJWxzT1rhf@mail.gmail.com>
Date: Fri, 18 Feb 2011 23:14:45 +0100
Message-ID: <AANLkTikOZu_Bq-y7vLHD6vQXSnJnMWZB7YtFWLxVHeMn@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p1IMEvUm018159

2011/2/18 Anca Emanuel <anca.emanuel@gmail.com>:
> Nouveau OpenGL regresion
>
> Tools used: http://packages.ubuntu.com/maverick/misc/glmark2
>
> With 2.6.38-rc5 latest git:
> nv50_screen_get_param:162 - Â Unknown PIPE_CAP 11
> ===================================================
> Â  Â glmark2 10.07.1
> ===================================================
> Â  Â OpenGL Information
> Â  Â GL_VENDOR: Â  Â  nouveau
> Â  Â GL_RENDERER: Â  Gallium 0.4 on NV92
> Â  Â GL_VERSION: Â  Â 2.1 Mesa 7.9-devel
> ===================================================
> Precompilation
> Â  Â Vertex array Â  Â  Â  Â  Â  Â  Â  Â  Â FPS: 105
> Â  Â Vertex buffer object Â  Â  Â  Â  Â FPS: 267
> Texture filtering
> Â  Â Nearest Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  FPS: 295
> Â  Â Linear Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â FPS: 299
> Â  Â Mipmapped Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  FPS: 308
> Shading
> Â  Â GLSL per vertex lighting Â  Â  Â FPS: 227
> Â  Â GLSL per pixel lighting Â  Â  Â  FPS: 260
> ===================================================
> Your glmark2 Score is 727 Â ^_^
> ===================================================
>
>
> With Linux ubuntu 2.6.35-25-generic #44-Ubuntu SMP Fri Jan 21 17:40:44
> UTC 2011 x86_64 GNU/Linux:
>
> nv50_screen_get_param:162 - Â Unknown PIPE_CAP 11
> ===================================================
> Â  Â glmark2 10.07.1
> ===================================================
> Â  Â OpenGL Information
> Â  Â GL_VENDOR: Â  Â  nouveau
> Â  Â GL_RENDERER: Â  Gallium 0.4 on NV92
> Â  Â GL_VERSION: Â  Â 2.1 Mesa 7.9-devel
> ===================================================
> Precompilation
> Â  Â Vertex array Â  Â  Â  Â  Â  Â  Â  Â  Â FPS: 265
> Â  Â Vertex buffer object Â  Â  Â  Â  Â FPS: 599
> Texture filtering
> Â  Â Nearest Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  FPS: 687
> Â  Â Linear Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â FPS: 683
> Â  Â Mipmapped Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  FPS: 717
> Shading
> Â  Â GLSL per vertex lighting Â  Â  Â FPS: 480
> Â  Â GLSL per pixel lighting Â  Â  Â  FPS: 524
> ===================================================
> Your glmark2 Score is 1628 Â ^_^
> ===================================================

You're yelling in thread about recent single drm fixes... and you
compare 2.6.35 with 2.6.38-rc5. What is possibility it's regression
introduced by one of that few commits?

Please report on bugzilla normally, perform bisecting, but do not
report such a things in unrelated places!

-- 
RafaÅ‚
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
