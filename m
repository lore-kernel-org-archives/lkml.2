Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702Ab0I0QDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:03:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2471 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390Ab0I0QDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:03:06 -0400
Subject: Re: [RFC v4]update broken web addresses in the kernel.
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <20100927151005.GC11086@tuxdriver.com>
References: <1285525875-9920-1-git-send-email-justinmattock@gmail.com>
	 <20100927151005.GC11086@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 09:03:03 -0700
Message-ID: <1285603383.1732.106.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 11:10 -0400, John W. Linville wrote:
> On Sun, Sep 26, 2010 at 11:31:15AM -0700, Justin P. Mattock wrote:
> > Below is an updated patch from the original fixing broken web addresses in the kernel.
> > Thanks for all the help and info on this to everybody..
> > Hopefully I didnt miss any of them(if so let me know, and I'll resend).
> Changing a URL for a relocated page is one thing, but removing links
> isn't necessarily a great idea.  Even if the site is technically
> gone, it may be possible to find information e.g through the Internet
> Archive Wayback Machine.

Perhaps it'd be better to scrape the contents of the various
web pages, collect them somewhere like wiki.kernel.org and
encourage others to put new contributions in that site.



