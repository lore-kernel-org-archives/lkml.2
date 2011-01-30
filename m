Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1A3RWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 12:22:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54303 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1A3RWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 12:22:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LbMv5yp9F24MAnXgNRPy8cpemOP4N5w7Zx5c/1y+cnW42khfCNTHmLB8vyDkR8NAxA
         1KQJ5NLQ7rlj6AX7HMr/LZE+RIVo5bJVFQSJ8Jf97WIWJSWupDGSVffj5TrqyfYGLS79
         JSjmVScjHlA01jzyomjUNPmzFp1wbFGpTK1P4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikjA=F7Q6zdZ8Gnq57NxBfr2vyU4eshmnZytw-m@mail.gmail.com>
References: <Pine.LNX.4.64.1101251740380.3737@boston.corp.fedex.com>
	<20110125151346.GB14803@khazad-dum.debian.net>
	<AANLkTim9cN8KXx5DVrH_nBzVjnmuYsxOHwP4msBKs=gS@mail.gmail.com>
	<20110126003034.GC25953@khazad-dum.debian.net>
	<AANLkTinazKxNF27m_PkE097hnfZtOqBuAmLZYXydWCpL@mail.gmail.com>
	<20110129175533.GB26442@khazad-dum.debian.net>
	<AANLkTikjA=F7Q6zdZ8Gnq57NxBfr2vyU4eshmnZytw-m@mail.gmail.com>
Date: Mon, 31 Jan 2011 01:22:31 +0800
Message-ID: <AANLkTin-rO5Uge9y3JDAG5rBe=iuJ2qSb02myzTqVJ6c@mail.gmail.com>
Subject: Re: [ibm-acpi-devel] thinkpad-acpi: fn-f4 issues
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dominik Kopp <my@kabelfunk.de>,
        ibm-acpi-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 1:55 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
>
> On Wed, 26 Jan 2011, Jeff Chua wrote:
>
> > xev reported both up/down. I'm using mplayer and it doesn't see those
> > events.
>
> Now I am confused.  Did you get any xev events for Fn+F4?  Or do you mean
> volume up/down?

No event for Fn+F4 with CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y, and
Suspend doesn't work.

With CONFIG_THINKPAD_ACPI_HOTKEY_POLL unset, Syspend works with Fn+F4.

xev reported events when volume up/down are pressed.

>
> > Mute is working fine.  And on a separate topic, I simply couldn't get the
> > "mic" to work. Alsamixer reported these ...
>
> I wouldn't know what to do about that, but I bet someone on the thinkpad-ml
> does, so maybe you should ask there.  You did check that the mic-mute button
> is not active, I assume?

There's no option to unmute the mic. I've tried alsamixer, but
couldn't find it there.

Thanks,
Jeff
