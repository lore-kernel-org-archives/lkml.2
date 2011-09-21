Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab1IUU53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:57:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1IUU51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:57:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] vt/suspend: cleanup #if defined uglyness and fix compile error
Date: Wed, 21 Sep 2011 22:59:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org,
        gregkh@suse.de, pavel@ucw.cz, len.brown@intel.com, art@ified.ca,
        jslaby@suse.cz
References: <201109061404.10301.hartleys@visionengravers.com> <201109071849.43603.arnd@arndb.de>
In-Reply-To: <201109071849.43603.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109212259.30843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 07, 2011, Arnd Bergmann wrote:
> On Tuesday 06 September 2011, H Hartley Sweeten wrote:
> > rder to cleanup
> > the #if defined ugliness for the vt suspend support functions. Note that
> > CONFIG_VT_CONSOLE is already dependant on CONFIG_VT.
> > 
> > The function pm_set_vt_switch is actually dependant on CONFIG_VT and not
> > CONFIG_PM_SLEEP. This fixes a compile error when CONFIG_PM_SLEEP is
> > not set:
> > 
> > drivers/tty/vt/vt_ioctl.c:1794: error: redefinition of 'pm_set_vt_switch'
> > include/linux/suspend.h:17: error: previous definition of 'pm_set_vt_switch' was here
> > 
> > Also, remove the incorrect path from the comment in console.c.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Arnd Bergmann <arnd@arnd.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Arthur Taylor <art@ified.ca>
> > Cc: Jiri Slaby <jslaby@suse.cz>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Applied to linux-pm/linux-next, will be pushed for 3.2.

Thanks (and sorry for the delay),
Rafael
