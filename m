Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0LFO5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:57:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35704 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0LFO5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:57:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RwUlFhJ/76hWS9K8HgVwBfN8f+ZvI5F2693gI3vIdKf71Z3LdET7u3MfxeA5z3GX1X
         wkjAxGA04nERxMM98VWRUoFnLUE1nxqUmhvVvcPoxHPQaGmTPzUXbqNTszftfFOiZ4hI
         iIjETPww6xb06hwZ+GQTRwG/Lg8xOcja7m3s0=
MIME-Version: 1.0
In-Reply-To: <201012061549.01534.arnd@arndb.de>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<AANLkTikMAWikj9HQ76YVeHr7pMoFK6ME2=HHpuQ1kUxq@mail.gmail.com>
	<AANLkTi=V+89hmBP8iqz13xMhYVfnBkbiVnk=FY=OBE8T@mail.gmail.com>
	<201012061549.01534.arnd@arndb.de>
Date: Mon, 6 Dec 2010 15:57:43 +0100
Message-ID: <AANLkTiku8_ZYHcsGVwyYffmRgc=5Wab1F=kNkOztNW-S@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Vitaly Wool <vitalywool@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 3:49 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> As far as I understand, the point is that it's no longer a 'solution'
> at the core, i.e. there is no replacement for hci_ldisc or any
> of these, just modules for the additional h4 protocols that don't
> have a linux implementation yet.
>
> The patch set that was originally posted here had a new framework,
> but after the comments from Alan and me, Par-Gunnar agreed to use
> the existing framework instead and extend it in a useful way.
> Please read all of the discussion we already had. You made a good
> point here, but I fear you had both Par-Gunnar and me confused
> because it was a point that already got resolved.

Yeah I've read through that thread but the only conclusion I'd been
able to make was that you agreed on not introducing yet another line
discipline. I'm not sure if I could make a conclusion that Par gave up
on his attempt to make his patchset generic/extensible/reusable for
other chips of similar type. But if that's really the case, I see no
point in this patchset at all, as opposed to generalizing the TI
shared transport thingie and using that one.

Thanks,
   Vitaly
