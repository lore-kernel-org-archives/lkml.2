Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2E2RIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:08:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63738 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2E2RIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120524102714.GA15990@elf.ucw.cz>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
 <1337714205-18038-1-git-send-email-snanda@chromium.org> <20120524102714.GA15990@elf.ucw.cz>
From: Sameer Nanda <snanda@chromium.org>
Date: Tue, 29 May 2012 10:08:01 -0700
X-Google-Sender-Auth: emKcUjVOokBcLCM0XWMQAauz5n8
Message-ID: <CANMivWYQ-hg09R8ORRx8u6A7tQ1uZuqQdWJVGj0Jp2mV+xgD5Q@mail.gmail.com>
Subject: Re: [PATCH] power: add knob for printing device resume times
To: Pavel Machek <pavel@ucw.cz>
Cc: len.brown@intel.com, rjw@sisk.pl, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 3:27 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2012-05-22 12:16:45, Sameer Nanda wrote:
>> Added a new knob called /sys/powe/pm_print_times. Setting it to 1
>> enables printing of time taken by devices to suspend and resume.
>> Setting it to 0 disables this printing (unless overridden by
>> initcall_debug kernel command line option).
>
> Did not we have nice module_param() interface that had kernel command
> line parameter _and_ sysfs file created with .. one line IIRC?
>
> Could that be used?

Not sure how/if that would help here?  The patch is adding a new sysfs
knob and not a a new kernel command line or module parameter.

>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Sameer
