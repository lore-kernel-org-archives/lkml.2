Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab0HBQuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:50:06 -0400
Received: from [198.24.6.8] ([198.24.6.8]:53276 "EHLO imr4.ericy.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750924Ab0HBQuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:50:04 -0400
X-Greylist: delayed 1915 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2010 12:50:03 EDT
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Greg KH <gregkh@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>, Paul Mackerras <paulus@samba.org>,
        Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Nick Cheng <nick.cheng@areca.com.tw>,
        James Smart <james.smart@emulex.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Benjamin Thery <benjamin.thery@bull.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
In-Reply-To: <20100730143622.GA30105@suse.de>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
	 <4C52913C.9020204@kernel.org> <1280485690.1902.8.camel@pasglop>
	 <20100730143622.GA30105@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 2 Aug 2010 09:15:24 -0700
Message-ID: <1280765724.5745.4.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 10:36 -0400, Greg KH wrote:
> On Fri, Jul 30, 2010 at 08:28:10PM +1000, Benjamin Herrenschmidt wrote:
> > On Fri, 2010-07-30 at 10:45 +0200, Tejun Heo wrote:
> > > On 07/29/2010 07:09 AM, Guenter Roeck wrote:
> > > > The following comment is found in include/linux/sysfs.h:
> > > > 
> > > >    /* FIXME
> > > >     * The *owner field is no longer used.
> > > >     * x86 tree has been cleaned up. The owner
> > > >     * attribute is still left for other arches.
> > > >     */
> > > > 
> > > > As it turns out, the *owner field is (again?) initialized in several modules,
> > > > suggesting that such initialization may be creeping back into the code.
> > > > 
> > > > This patch set removes the above comment, the *owner field, and each instance
> > > > in the code where it was found to be initialized.
> > > > 
> > > > Compiled with x86 allmodconfig as well as with all alpha, arm, mips, powerpc,
> > > > and sparc defconfig builds.
> > > 
> > > Yeah, the change is way overdue.  Maybe we should have just removed
> > > them back then.
> > 
> > I'm happy with the powerpc related patches as long as we all agree that
> > needs to go. Do you need me to put some of this in powerpc.git or are
> > you carrying them all to Linus ?
> 
> I can carry them all in my driver-core tree if you don't object.
> 
Any final verdict ? 

Not that it is my decision to make, but I think it would be better to
have it all in one tree. Otherwise the timing for the last patch would
get a bit complicated.

Thanks,
Guenter


