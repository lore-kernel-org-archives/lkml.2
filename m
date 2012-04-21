Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2DULkd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:40:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65344 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2DULkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:40:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: clps711x patchset
Date: Sat, 21 Apr 2012 11:40:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alexander Shiyan <shc_work@mail.ru>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201204211140.21564.arnd@arndb.de>
X-Provags-ID: V02:K0:nS0ggCPJSp0ziI2ESrXLbB3QMPq14ZG0+t3XEv3pKPN
 iyGqEVR8FWgbGeZlfUwDE6zT7lTUP1vPnj9bPZ5vaR6tGTXGVv
 haZowQbRStpSJRRlkjc/1z0OQzFDroLwo/QSFWxyyULaesiOJa
 Bdn4ikTKPY/QMdXlwJvGrsRe7ti/be/2H3Ne7vU1eAcnSwmW1x
 qsH2iyCfF1e9o4VoYZuOwtEfxeZWgafsBgULvkTkOnrWa5HGTZ
 2Z77l3z0pttDbA7bQaT+U4oQo3tLSg8xTljFGckw5phjAetNjk
 isEyA/N0xnjYLUISrBB2KfebdO3gy4sRJN5viwNJ3acvdUUR0g
 tASiqAwJ8k8xLqD8IQWw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2012, Alexander Shiyan wrote:
> Hello.
> This is patchset contains some cleanups and tricks for CLPS711X ARM target.
> Please review and apply it to kernel tree. Comments are welcome :)

Hi Alexander,

This looks very nice overall, it's certainly good that you can manage to add
support for a new soc with a net removal of lines.

Note that with the current work split, it will be Olof and me who apply
these patches in the end, not Russell, although he will probably have
to something to say about the patches, too, since he has done almost all the
changes to this platform in its more active times.

>From my reading of the git history, very little has happened in clps711x
since about 2005, and we've never had a subarch maintainer for it. Are you
interested in becoming the maintainer for it, or is this more a one-time
effort on your side? I don't expect this to be much work for you, but it
would be nice to have some person that can review the occasional patch
touching multiple platforms.

Do you have any plans to add more stuff to the platform, like additional
SoCs or more board files? Do you see value in having it included in
a single kernel image that runs on various different ARMv4/ARMv5 based
Socs? I assume that the answer to all of these is 'no', but you plan
to do them, we should talk about how to make that happen.

	Arnd
