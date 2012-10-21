Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab2JULI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 07:08:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47663 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab2JULIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 07:08:55 -0400
Date: Sun, 21 Oct 2012 13:08:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Re: Re: Re: A reliable kernel panic (3.6.2) and system crash
 when visiting a particular website
Message-ID: <20121021110851.GA6504@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Artem S. Tashkinov" <t.artem@lycos.com>, pavel@ucw.cz,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	security@kernel.org, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020203227.GC555@elf.ucw.cz>
 <20121020225849.GA8976@liondog.tnic>
 <1781795634.31179.1350774917965.JavaMail.mail@webmail04>
 <20121021002424.GA16247@liondog.tnic>
 <1798605268.19162.1350784641831.JavaMail.mail@webmail17>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1798605268.19162.1350784641831.JavaMail.mail@webmail17>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 01:57:21AM +0000, Artem S. Tashkinov wrote:
> The freeze happens on my *host* Linux PC. For an experiment I decided
> to check if I could reproduce the freeze under a virtual machine - it
> turns out the Linux kernel running under it also freezes.

I know that - but a freeze != oops - at least not necessarily. Which
means it could very well be a different issue now that vbox is gone.

Or, it could be the same issue with different incarnations: with vbox
you get the corruptions and without it, you get the freezes. I'm
assuming you do the same flash player thing in both cases?

Here's a crazy idea: can you try to reproduce it in KVM?

Thanks.

-- 
Regards/Gruss,
    Boris.
