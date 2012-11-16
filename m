Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2KPRJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:09:16 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46050 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2KPRJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:09:14 -0500
MIME-Version: 1.0
In-Reply-To: <20121116170616.GB30626@kroah.com>
References: <1353084911-8908-1-git-send-email-johanmeiring@gmail.com>
	<20121116170616.GB30626@kroah.com>
Date: Fri, 16 Nov 2012 19:09:14 +0200
Message-ID: <CALqZ13upXn+BZhzHOHuudqcQ23-2ZUF9X11qR4ESy0_B4pzRbw@mail.gmail.com>
Subject: Re: [PATCH 3/3] staging: wlags49_h2: mdd.h: fixes tons of coding
 style issues
From: Johan Meiring <johanmeiring@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will do.  Just a quick question: Is it acceptable to submit small
patches even if the main file still fails the checkpatch,pl script?
i.e. is it OK to fix e.g. the first 20 instances of C99 // comment
usage, even if 200 remain afterwards, and then fix them later?

Johan

On 16 November 2012 19:06, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 16, 2012 at 06:55:11PM +0200, Johan Meiring wrote:
>> This commit sorts out a ton of styling issues, including the use of
>> C99 // comments, spaces before and after tabs, etc. I also took the
>> time to align stuff a little more neatly using tabs. The file is
>> nowhere near ready, but it's a start.
>>
>> Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
>> ---
>>  drivers/staging/wlags49_h2/mdd.h | 1593 +++++++++++++++++++-------------------
>>  1 file changed, 797 insertions(+), 796 deletions(-)
>
> A patch this big is almost impossible to review, sorry.  Please break it
> up into smaller pieces.
>
> thanks,
>
> greg k-h
