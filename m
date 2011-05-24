Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1EXPHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:07:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53631 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1EXPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:07:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YlULh3HHnbmm+iK1k8Hp2JRZMM33wFkwDZZzI+HCuIk+K/yc58tdl2JkjR2p4BT3TY
         YaomBrrT5wucE/FOZUtvaBHD6Fk3PTiULb5xPr2pKHrQM2b8mzV34aTEqrxZqoc5mZYJ
         4KkGU7/lPAaBPYlwpJ1k23AsqcLT7HabjVnko=
MIME-Version: 1.0
In-Reply-To: <20110524154348.27ba649d@lxorguk.ukuu.org.uk>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<20110523192056.GC23629@elte.hu>
	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
	<20110523231721.GM10009@thunk.org>
	<4DDAEC68.30803@zytor.com>
	<BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com>
	<alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr>
	<BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com>
	<alpine.LNX.2.01.1105241500410.23085@frira.zrqbmnf.qr>
	<BANLkTinNK+9XijCN0YGXyvLQ8_npPTG2cQ@mail.gmail.com>
	<20110524154348.27ba649d@lxorguk.ukuu.org.uk>
Date: Tue, 24 May 2011 11:07:45 -0400
Message-ID: <BANLkTi=Xuk4=Q43QV1pv33K=J2FFZBLLtQ@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
        Jan Engelhardt <jengelh@medozas.de>, linux-arch@vger.kernel.org,
        "linux-mm <linux-mm"@kvack.medozas.de, "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Can we drop most of MCA, EISA and ISA bus if we are going to have a big
> version change ? A driver spring clean is much overdue and it's all in
> git in case someone wishes to sneak out at midnight and bring some crawly
> horror back from the dead.

2.8 could mark the beginning of the great cleanup
  --- work out the details of what needs to be cleaned and set a goal
  --- remove old buses/driver, switch to device tree, graphics, 32/64
merges, etc
3.0 would mark its completion

-- 
Jon Smirl
jonsmirl@gmail.com
