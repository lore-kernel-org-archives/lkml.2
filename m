Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0K2CaB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:30:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56121 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab0K2CaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:30:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tsbaLA64mmOXmNx0z55XR3zxXFVz8V7TErycL72+7ecpxwSuEFx3IfPoc+yf1HTz1s
         xoqO4r+4ztDk5Lg8DCowmtDjPcbMCfSGIWI7I1XJcgm6tpif7gp14rJUfzxjWescdfcA
         lxskCKcXykrZrQfcW92BWNaubYGp17vN+joL8=
MIME-Version: 1.0
In-Reply-To: <4CF30B46.4000203@pavlinux.ru>
References: <4CF30B46.4000203@pavlinux.ru>
Date: Mon, 29 Nov 2010 10:29:38 +0800
Message-ID: <AANLkTikjDfyWY=Gy7VkdvEGNnYB9kb_iCqNDP7H9W5z4@mail.gmail.com>
Subject: Re: [PATCH] Repalce strncmp by memcmp
From: Ming Lei <tom.leiming@gmail.com>
To: pavel@pavlinux.ru
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/11/29 Pavel Vasilyev <pavel@pavlinux.ru>:
>
>    This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
>
> I test on x86_64 (AMD Opteron 285).

In fact, memcmp doesn't handle case of tail of string, so
it is not safe to replace strncmp with memcmp

thanks,
-- 
Lei Ming
