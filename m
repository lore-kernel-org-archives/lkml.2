Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab0DHNIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 09:08:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712Ab0DHNIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:08:47 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc3++ looses PS2 keyboard eventually in xterms
Date: Thu, 8 Apr 2010 15:08:37 +0200
User-Agent: KMail/1.9.10
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201004080040.41373.hpj@urpla.net>
In-Reply-To: <201004080040.41373.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004081508.38047.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1887sOPndOWbqSTyoMP3ZMBeJZXn57L4evIdMu
 L6KskX4MOSQ0aM1xeo07QQVQPgPYxWD5z+r0AZl4e8ko0wLTCc
 xMHTITZ3JHrTwK5T5sO9VnpVm6iYG0X
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010, 00:40:41 Hans-Peter Jansen wrote:
> Hi,
>
> after switching to 2.6.34-rc3 with follow ups added up to 5e11611a (e.g.
> including the tty fix), I still suffer from "loosing" my PS2 keyboard
> eventually during work in xterms (which I do use a lot). Everything else,
> ssh'ing from remotes, mouse operations, even mouse clicks into xterms is
> still functional, e.g. I'm able to quit htop by clicking on F10. Just
> every direct keyboard input is lost, without a trace in syslog, as well
> as Alt-SysReq sequences. echo r > /proc/sysrq-trigger doesn't show any
> effects either. AFAICT, it doesn't happen with older kernels
> (2.6.33.2/2.6.27.y).

Correction: 2.6.33.2 is affected as well. Problem is, I don't know a 
procedure, that reproduces the issue reliable, thus bisecting is not an 
option.

sysrq triggered process and lock state trace (when the keyboard was "lost") 
is available here: ftp://urpla.net/xrated-kbd-lockup

Dmitry, I've CC'ed you, since you seems the premier guy for input related 
issues. Do you have an idea? I guess, that my hardware setup isn't that 
uncommon, my keyboard is a "solid as a rock" Cherry G80, btw.

> OS/Hardware:
> openSUSE 11.1/i586, KDE3, ASUS P7P55-WS, Xeon X3460, 4 GB.
>
> Any hint on how to debug such an issue is much appreciated.
>
> Thanks,
> Pete
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


