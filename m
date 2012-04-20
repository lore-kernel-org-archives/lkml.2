Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2DTQZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:25:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49203 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2DTQZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:25:34 -0400
Date: Fri, 20 Apr 2012 09:25:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Subject: Re: [PATCH v8 resend 6/6] Documentation/extcon: porting guide for
 Android kernel switch driver.
Message-ID: <20120420162529.GA31744@kroah.com>
References: <20120420033209.GA17930@kroah.com>
 <1334898987-7800-1-git-send-email-myungjoo.ham@samsung.com>
 <1334898987-7800-7-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334898987-7800-7-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 02:16:27PM +0900, MyungJoo Ham wrote:
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/extcon/porting-android-switch-class |  124 +++++++++++++++++++++

Ok, I've applied this, but I don't know if we really need this in the
kernel tree.  How many out-of-tree android switch drivers are there?
Who needs to know this information?

thanks,

greg k-h
