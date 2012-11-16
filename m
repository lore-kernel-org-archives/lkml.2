Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2KPRdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:33:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59627 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2KPRdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:33:00 -0500
Date: Fri, 16 Nov 2012 09:32:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: wlags49_h2: mdd.h: fixes tons of coding
 style issues
Message-ID: <20121116173256.GB31589@kroah.com>
References: <1353084911-8908-1-git-send-email-johanmeiring@gmail.com>
 <20121116170616.GB30626@kroah.com>
 <CALqZ13upXn+BZhzHOHuudqcQ23-2ZUF9X11qR4ESy0_B4pzRbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALqZ13upXn+BZhzHOHuudqcQ23-2ZUF9X11qR4ESy0_B4pzRbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:09:14PM +0200, Johan Meiring wrote:
> Will do.  Just a quick question: Is it acceptable to submit small
> patches even if the main file still fails the checkpatch,pl script?
> i.e. is it OK to fix e.g. the first 20 instances of C99 // comment
> usage, even if 200 remain afterwards, and then fix them later?

Yes, that is fine.

thanks,

greg k-h
