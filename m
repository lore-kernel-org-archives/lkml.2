Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0I3UhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:37:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50678 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab0I3UhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pXFPegDEQblSlKTtC69S2M+49Mr75c/9Iagq93nB6z0mG8++dHKI/HIAZA/NX4GtKv
         D1cMB1vQ4jgh9MD42bgJxXhYNDH2ICVbhZXZ/d6vkg4Kr7WkB+TPolrgqrQAkyixbBjj
         hIUvcVjIER8V2xOn9JLg5yQss4d2Gmfd2yG6s=
MIME-Version: 1.0
In-Reply-To: <4CA4F10E.5060109@zytor.com>
References: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com>
	<AANLkTinnRB-cpRrxymUQYMx0TjgkDkSbg=Euaq+Y16sE@mail.gmail.com>
	<4CA4F10E.5060109@zytor.com>
Date: Thu, 30 Sep 2010 22:37:07 +0200
X-Google-Sender-Auth: UuAcds1Joxlg9BxbGIkR0J-DHvc
Message-ID: <AANLkTinQG-Jt5CVuYPrAFO2nYAkyKEt++SPC+sGKKUDr@mail.gmail.com>
Subject: Re: [PATCH 1/2] autofs: Only declare function when CONFIG_COMPAT is defined
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?TcOhcnRvbiBOw6ltZXRo?= <nm127@freemail.hu>,
        Arnd Bergmann <arnd@arndb.de>, Ian Kent <raven@themaw.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 22:20, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/30/2010 01:00 PM, Geert Uytterhoeven wrote:
>>
>> An alternative (and IMHO better) fix would be to move autofs_root_operations[]
>> and autofs_root_inode_operations[] to the bottom of the file, and get rid of all
>> the forward declarations.
>>
>
> This is a legacy piece of code (autofs3) which has been long since
> obsolete anyway... it's one thing to do a minimal patch to keep it
> alive, another to restructure crap when it's already overdue for removal.

You're right. But please note that autofs4 has the exact same issue.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
