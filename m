Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0HBXcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:32:12 -0400
Received: from kroah.org ([198.145.64.141]:47990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0HBXcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:32:11 -0400
Date: Mon, 2 Aug 2010 16:31:28 -0700
From: Greg KH <greg@kroah.com>
To: Eric Biederman <ebiederm@aristanetworks.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dtor@mail.ru>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Nick Cheng <nick.cheng@areca.com.tw>,
        James Smart <james.smart@emulex.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
Message-ID: <20100802233128.GA21286@kroah.com>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
 <AANLkTinM+m15QbAg+J3YyHWnObsxtHYYU6p6C89p8wjp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinM+m15QbAg+J3YyHWnObsxtHYYU6p6C89p8wjp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 11:16:35PM -0700, Eric Biederman wrote:
> On Wed, Jul 28, 2010 at 10:09 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > The following comment is found in include/linux/sysfs.h:
> >
> >   /* FIXME
> >    * The *owner field is no longer used.
> >    * x86 tree has been cleaned up. The owner
> >    * attribute is still left for other arches.
> >    */
> >
> > As it turns out, the *owner field is (again?) initialized in several modules,
> > suggesting that such initialization may be creeping back into the code.
> >
> > This patch set removes the above comment, the *owner field, and each instance
> > in the code where it was found to be initialized.
> >
> > Compiled with x86 allmodconfig as well as with all alpha, arm, mips, powerpc,
> > and sparc defconfig builds.
> 
> This seems reasonable to me.  Can we get this in linux-next?

It will show up in linux-next tomorrow.

thanks,

greg k-h
