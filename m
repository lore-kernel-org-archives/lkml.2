Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab0HJQrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:47:16 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58499 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab0HJQrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:47:12 -0400
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        James Smart <james.smart@emulex.com>,
        Eric Biederman <ebiederm@aristanetworks.com>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Wright <chrisw@sous-sol.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Nick Cheng <nick.cheng@areca.com.tw>, Dmitry Torokhov <dtor@mail.ru>,
        Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        David Woodhouse <David.Woodhouse@intel.com>
In-Reply-To: <20100811012001.6fb50655.sfr@canb.auug.org.au>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
	 <AANLkTinM+m15QbAg+J3YyHWnObsxtHYYU6p6C89p8wjp@mail.gmail.com>
	 <20100802233128.GA21286@kroah.com>
	 <20100810154337.006a0df9@hyperion.delvare>
	 <20100811011733.16243ddb.sfr@canb.auug.org.au>
	 <20100811012001.6fb50655.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 10 Aug 2010 09:43:17 -0700
Message-ID: <1281458597.5745.255.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 11:20 -0400, Stephen Rothwell wrote:
> Hi Jean,
> 
> On Wed, 11 Aug 2010 01:17:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Tue, 10 Aug 2010 15:43:37 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> > >
> > > Related bug?
> > > 
> > > https://bugzilla.kernel.org/show_bug.cgi?id=16544
> > 
> > Yep, fixed in linux-next today - hopefully the fix is on its way to Linus.
> 
> Sorry, more info:
> 
> Fixed by commit 690e85a3957291f4cfe0cac22d97994ec7e5ee45 ("olpc_battery:
> Fix build failure caused by sysfs changes") from the battery tree.

Excellent. Guess the patch I sent out earlier today to fix the problem
wasn't needed then.

Guenter


