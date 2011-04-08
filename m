Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab1DHE6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 00:58:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21039 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1DHE6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 00:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H6fMe2fgoyCOhzOcYGuTCFFDS/fLlyT+GiAj3mxNZ67l2ONFm8AeCM4euAlVqrTC6f
         ZhpUn4t17ENf4Wjajs9w==
MIME-Version: 1.0
In-Reply-To: <20110408003742.GD3942@ericsson.com>
References: <1302211560-8052-1-git-send-email-natg@google.com>
	<20110408003742.GD3942@ericsson.com>
Date: Thu, 7 Apr 2011 21:58:05 -0700
Message-ID: <BANLkTimsB9EoOVq1fojcazU4GCFyqPmF=w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Make all it87 drivers SMP safe.
From: Natarajan Gurumoorthy <natg@google.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,
      Comments are below

On Thu, Apr 7, 2011 at 5:37 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
>
> Did you consider naming this file include/linux/it87.h as suggested ?
> I thought that was a goodd idea.
>
This does seem to be a good idea. I had some other thoughts about
where to place the
it87_lock.c file. One thought was to move the lock into the
drivers/mfd directory and
completely decouple the lock from the watchdog or the hwmon
directories. The mfd/Kconfig
would contain the IT87_LOCK.

> When you send out new versions of your patch set, it would be prudent
> to list the patch version, as well as the changes made compared to previous
I am new at this. Exactly where do you list the patch version. I put
v2 in the subject line.
The only difference between the 2 patch sets was that each of the patches has a
more verbose body section explaining the contents of the patch and
each of the sub patch
Subject line reflected what was happening in that sub patch. I also
made sure I had the
"In-Reply-To" entry in the patches.

Where in the patch do you discuss the changes made with respect to the
previous patch.

When I send out the next set of patches do I have to send out the
entire patch set marked as v3.

> versions of your patch. See Documents/SubmittingPatches, rule #2.
>
> Thanks,
> Guenter



--
Regards
Nat Gurumoorthy AB6SJ
