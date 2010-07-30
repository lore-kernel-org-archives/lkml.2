Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab0G3Iqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 04:46:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:59290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791Ab0G3Iqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 04:46:42 -0400
Message-ID: <4C52913C.9020204@kernel.org>
Date: Fri, 30 Jul 2010 10:45:48 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: "James E.J. Bottomley" <James.Bottomley@suse.de>,
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
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Jul 2010 08:45:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 07:09 AM, Guenter Roeck wrote:
> The following comment is found in include/linux/sysfs.h:
> 
>    /* FIXME
>     * The *owner field is no longer used.
>     * x86 tree has been cleaned up. The owner
>     * attribute is still left for other arches.
>     */
> 
> As it turns out, the *owner field is (again?) initialized in several modules,
> suggesting that such initialization may be creeping back into the code.
> 
> This patch set removes the above comment, the *owner field, and each instance
> in the code where it was found to be initialized.
> 
> Compiled with x86 allmodconfig as well as with all alpha, arm, mips, powerpc,
> and sparc defconfig builds.

Yeah, the change is way overdue.  Maybe we should have just removed
them back then.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
