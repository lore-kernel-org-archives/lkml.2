Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab2C1Oo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:44:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57351 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab2C1Oo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:44:56 -0400
Date: Wed, 28 Mar 2012 07:44:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, cw00.choi@samsung.com
Subject: Re: [PATCH v7 0/6] Introduce External Connector Class (extcon)
Message-ID: <20120328144450.GA19030@kroah.com>
References: <1332492784-10526-1-git-send-email-myungjoo.ham@samsung.com>
 <CAJ0PZbTScHq0MMjSWZ0X5qHChhS+6TL-xSnsqEwS34N2VFLaSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0PZbTScHq0MMjSWZ0X5qHChhS+6TL-xSnsqEwS34N2VFLaSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 06:39:08PM +0900, MyungJoo Ham wrote:
> Dear Arnd,
> 
> Could you please consider the EXTCON patchset for the current merge window?

Wait, no, the current merge window for new stuff closed a week or so
_before_ 3.3 came out.  This needs to be in linux-next before the merge
window opens to ensure that things work properly there before it can be
accepted into the mainline tree.

So this could go into 3.5 at the earliest.

thanks,

greg k-h
