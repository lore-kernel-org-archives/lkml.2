Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2EHRjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:39:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49502 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2EHRjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:39:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120508165118.GA11750@merkur.ravnborg.org>
References: <20120428205651.GA7426@merkur.ravnborg.org>
	<20120428205919.GC7442@merkur.ravnborg.org>
	<4FA460AB.6060309@suse.cz>
	<20120505082916.GA14006@merkur.ravnborg.org>
	<CA+8MBbKd9zAouJy5JvUnLwUHMJ65HsYgCTfBgv42nm32EnMPFA@mail.gmail.com>
	<20120508165118.GA11750@merkur.ravnborg.org>
Date: Tue, 8 May 2012 10:39:03 -0700
Message-ID: <CA+8MBbJHH1niHHR7md844UwphmeYczYQBJOB3huGFaxU9AXMTA@mail.gmail.com>
Subject: Re: [PATCH 3/4] kbuild: link of vmlinux moved to a script
From: Tony Luck <tony.luck@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 9:51 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> -       local aflags="${KBUILD_AFLAGS} ${NOSTDINC_FLAGS}                     \
> -                     ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
> +       local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
> +                     ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"

Heh. When I first got in this morning your e-mail hadn't arrived yet.
So I ran some make V=1 on the old and latest tree and saw the problem
was missing KBUILD_AFLAGS_KERNEL. I was just about to send this
exact patch to you.

So yes ... it works.

Tested-by: Tony Luck <tony.luck@intel.com>

Thanks

-Tony
