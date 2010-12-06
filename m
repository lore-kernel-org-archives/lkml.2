Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0LFPS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:18:27 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:58684 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0LFPSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:18:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k49/CDSj4f+SCaNDAUYtv7TqGkuOF0psE08NFKugz/9XC8ueV3iXMHT83IgwZuyJro
         ExyzjRB+OlesK+0L5kK7vvi+5Nt85R8Y8JT2Mh0tkUZG/WADVEpkpJBoQT4cvTqu3Rld
         /hm4pj9DILsK33GNHvhovWSVzY+kpXCMSTGKc=
MIME-Version: 1.0
In-Reply-To: <1dda71ee1b12baa2366520b894d83d7b0abefc5c.1291433779.git.tfransosi@gmail.com>
References: <1dda71ee1b12baa2366520b894d83d7b0abefc5c.1291433779.git.tfransosi@gmail.com>
Date: Mon, 6 Dec 2010 17:18:23 +0200
Message-ID: <AANLkTinJNzjkWFpSW2BRmHjC-KLPwnxbM=rLr+juaS+i@mail.gmail.com>
Subject: Re: [PATCH] drivers/video/via/viafbdev.c: Check return value of strict_strtoul().
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joseph Chan <JosephChan@via.com.tw>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 5:38 AM, Thiago Farina <tfransosi@gmail.com> wrote:
> This fix the following warnings:
>
> drivers/video/via/viafbdev.c:1144: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result

I send patches to convert this code to kstrto*() interfaces,
so this patch would be redundant.
