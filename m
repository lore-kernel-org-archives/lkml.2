Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab0G3K41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:56:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:42163 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab0G3K4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:56:25 -0400
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Paul Mackerras <paulus@samba.org>,
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
        Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <4C52913C.9020204@kernel.org>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
	 <4C52913C.9020204@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 20:28:10 +1000
Message-ID: <1280485690.1902.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 10:45 +0200, Tejun Heo wrote:
> On 07/29/2010 07:09 AM, Guenter Roeck wrote:
> > The following comment is found in include/linux/sysfs.h:
> > 
> >    /* FIXME
> >     * The *owner field is no longer used.
> >     * x86 tree has been cleaned up. The owner
> >     * attribute is still left for other arches.
> >     */
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
> Yeah, the change is way overdue.  Maybe we should have just removed
> them back then.

I'm happy with the powerpc related patches as long as we all agree that
needs to go. Do you need me to put some of this in powerpc.git or are
you carrying them all to Linus ?

Cheers,
Ben.

>  Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thanks.
> 


