Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab0ICMB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:01:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab0ICMB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:01:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Fri, 3 Sep 2010 14:01:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier.adi@gmail.com>,
        Roger Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201008311126.45190.arnd@arndb.de> <AANLkTinUjfWqEdOQoomR=TZnQEsiGj1wxvbv5c_MtZKp@mail.gmail.com>
In-Reply-To: <AANLkTinUjfWqEdOQoomR=TZnQEsiGj1wxvbv5c_MtZKp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009031401.39224.arnd@arndb.de>
X-Provags-ID: V02:K0:USyrBbIyKf9lR1UoDSDvzIV1G1ZFHFr4IlzVjWXPVSk
 J/Nwt3lKN+VvRLbh5zx5R+MxGixMpQZIeriBZPLC8Sm9ll/cUg
 EFMb5mR9w6FYzsYHBfVxsbg+WceVYqj4wBwF42YeF5VfDX8UiY
 aY2UDfJwuXiWaPBB/LYZRIKUrkq+bLNtTygCUIcvJD07Y0q855
 b+iJPVa9xdZy5t06iEwJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 September 2010, Geert Uytterhoeven wrote:
> On Tue, Aug 31, 2010 at 11:26, Arnd Bergmann <arnd@arndb.de> wrote:
>   - generic_serial-based:
> 
>       o MVME147_SCC
>       o MVME162_SCC
>       o BVME6000_SCC
>       o A2232
> 
>     All of these were marked BROKEN lately due to generic_serial,
> while there's even a
>     new ATARI_SCC under "active" development...

Ok, so I'll keep the plan of moving generic_serial to staging.
 
>   - plain drivers/char:
> 
>       o SERIAL167
>       o AMIGA_BUILTIN_SERIAL

Since these are the builtin ports for the Amiga and MVME16x
platforms, I suppose we should keep them around as long as the
platforms themselves are there and the code builds.

>   - drivers/serial:
> 
>       o SERIAL_PMACZILOG (Mac)
> 
>     Sun 3/3x support might be (re)added to SERIAL_SUNZILOG

Same category I guess.

Thanks for your feedback!

	Arnd
