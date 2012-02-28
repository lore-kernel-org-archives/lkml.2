Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2B1RCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:02:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53474 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2B1RCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:02:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.224.229 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Tue, 28 Feb 2012 09:02:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PULL-REQUEST] EXTCON Patches (Re: [PATCH v6 0/5] Introduce
 External Connector Class (extcon))
Message-ID: <20120228170246.GA11415@kroah.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
 <20120228164413.GA11021@kroah.com>
 <20120228165727.GO3683@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228165727.GO3683@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 04:57:28PM +0000, Mark Brown wrote:
> On Tue, Feb 28, 2012 at 08:44:13AM -0800, Greg KH wrote:
> 
> > Wait, please, before this code can be accepted, I would like to get
> > verification that you have also made the needed changes to the Android
> > userspace side of this interface, and that the code works there, and it
> > is on its way to be included in the main Android repo.
> 
> > Is this true?  If not, what is the plans for this to happen?  Without
> > that happening, I don't think this code can be accepted, do you?
> 
> There's a few more kernel changes needed there before full acceptance
> would be possible - for example, should have an integration into the
> audio stack as one of the uses of the switch API on Android is for
> headset detection.

Is this integration planned?
