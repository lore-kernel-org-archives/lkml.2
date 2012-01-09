Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418Ab2AIUX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:23:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48208 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab2AIUX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:23:27 -0500
MIME-Version: 1.0
In-Reply-To: <1326077816.4097.8.camel@deadeye>
References: <1326055714.13595.309.camel@deadeye> <CA+55aFwwnJPpVY++Vgr6p3s47YjdYWV3sgLZzvCtiJp6DEu78Q@mail.gmail.com>
 <1326077272.4097.3.camel@deadeye> <1326077816.4097.8.camel@deadeye>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2012 12:23:04 -0800
X-Google-Sender-Auth: Qb1___tugsxnYDSQFsXcHIGJHhY
Message-ID: <CA+55aFzz3FUsKRQ33NiDghkA3ugV65sBrc+N-h8NLuDRUSBAHQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] topology: Check for missing CPU devices
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 6:56 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>
> I mean to say that we could have no CPU devices after the *second*
> patch.  So the first patch is an extra defence against that.  (Though we
> could just as well panic if register_cpu() fails at boot time.)

I think I'd rather just panic - if you have allocation issues during
early boot, the machine is hosed anyway - and then get rid of the
first patch?

Willing to send out a new patch along those lines (and with UML added)?

Thanks,
                  Linus
