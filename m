Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab2DTQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:27:16 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47701 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2DTQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:27:14 -0400
Date: Fri, 20 Apr 2012 09:27:10 -0700
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
Subject: Re: [PATCH v8 resend 0/6] Introduce External Connector Class (extcon)
Message-ID: <20120420162710.GA6416@kroah.com>
References: <20120420033209.GA17930@kroah.com>
 <1334898987-7800-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334898987-7800-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 02:16:21PM +0900, MyungJoo Ham wrote:
> In order to address such issues, Android kernel's "Switch" class seems to
> be a good basis and we have implemented "Multistate Switch Class" based on
> it. The "Switch" class code of Android kernel is GPL as well.

Ok, I've applied these patches to my driver-core tree, thanks so much
for working to clean this up and get it merged, very nice job.

Now, does this mean I can delete the drivers/staging/android/switch/
directory from the tree as well?

If so, I will be glad to do that.

If not, what is left to do in order for it to be removed?

thanks,

greg k-h
