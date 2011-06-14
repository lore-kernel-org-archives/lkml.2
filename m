Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1FNBGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:06:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45098 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1FNBG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wd5naJn6tBpK6Q7YGgp9Q6+Fw5V6qG0BXY9S+TBoSpC98gfeY7+Wz4qO/kPtd2Fw2d
         BNyDTerm1j0lZhcrAJQe2LabUJOlsOHT01j4xKz0p3ZwFQ7IDH8b4shKc6U6oUroqXyM
         t38SHr6SqS31JerMM+CcmCy71xp946aXgpEiw=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=snWs0srAKON71yysvFcN_HHO05Q@mail.gmail.com>
References: <BANLkTi=i-NDzgsT2mCqL0p+r5ok_-=znGdWDYV-oi9z-8e9LvQ@mail.gmail.com>
	<BANLkTi=snWs0srAKON71yysvFcN_HHO05Q@mail.gmail.com>
Date: Tue, 14 Jun 2011 03:06:27 +0200
Message-ID: <BANLkTimqmcY1ciKkbZZ50Kg7nCm+_S7zK-9EHaxaQeC_HpKaaQ@mail.gmail.com>
Subject: Re: [3.0.0-rc2+][nouveau] BUG: unable to handle kernel NULL pointer
 dereference nv50_vm_map_sg+0x37/0xb0
From: Jan Seiffert <kaffeemonster@googlemail.com>
To: =?UTF-8?Q?Rui_Tiago_Ca=C3=A7=C3=A3o_Matos?= <tiagomatos@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/13 Rui Tiago Cação Matos <tiagomatos@gmail.com>:
> Looks suspiciously like
> https://bugzilla.redhat.com/show_bug.cgi?id=699551 which has been
> happening since at least 2.6.38.
>

Yes, the backtrace looks very similar, but i can not reproduce with
the reproducer image attached to the bugreport.
(Tried with Gwenview and eog).
I don't know how to reproduce at all, all i did was to scroll through
a PDF, but did so for hours before the crash...

> Rui
>

Greetings
Jan
