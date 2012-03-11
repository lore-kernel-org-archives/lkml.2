Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab2CKHgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 03:36:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54220 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2CKHgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 03:36:04 -0400
Date: Sat, 10 Mar 2012 23:35:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.3-rc6
Message-ID: <20120311073556.GA15408@core.coreip.homeip.net>
References: <20120307091816.GA28160@core.coreip.homeip.net>
 <CAMuHMdUyCEVr+fFmUnUABSG33juYTWdyy6-6a1uNW0+oePJR6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUyCEVr+fFmUnUABSG33juYTWdyy6-6a1uNW0+oePJR6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 11:11:17PM +0100, Geert Uytterhoeven wrote:
> On Wed, Mar 7, 2012 at 10:18, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > Dmitry Torokhov (1):
> >      Input: twl4030-vibra - use proper guard for PM methods
> 
> That's commit f3761c0779b62276b5bf84532a81d5dc49bd721f?
> 
> | drivers/input/misc/twl4030-vibra.c:175:5: warning: "CONFIG_PM" is not
> | defined
> |
> | We should use #ifdef instead of #if and also check CONFIG_PM_SLEEP
> | instead of CONFIG_PM.
> 
> It still uses "#if CONFIG_PM_SLEEP", i.e. no #ifdef.
> 

Doh! I'll fix it up...

-- 
Dmitry
