Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1IXEKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 00:10:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1IXEKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 00:10:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=Z4tJhY3T3u6GWHXkH7UPo11PEb7xAQZ6nJgQscKVBUIJF+4eWzl3H1rFNEJbzhcJB
	U+2PSqDayHkBemb9PGq9A==
MIME-Version: 1.0
In-Reply-To: <37959.1316820861@turing-police.cc.vt.edu>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
	<37959.1316820861@turing-police.cc.vt.edu>
Date: Fri, 23 Sep 2011 21:10:30 -0700
X-Google-Sender-Auth: -IvB4GD_rDk5WlNQTAgArAs-c0Q
Message-ID: <CAPnjgZ3P0aHbvXagd0QsxmRCw+1mTWNZb6HhwJheTd8XL1-6Wg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
From: Simon Glass <sjg@chromium.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 4:34 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 23 Sep 2011 16:03:15 PDT, Simon Glass said:
>> This experimental patch set adds boot timing to a Linux system. The
>> timing starts with the boot loader and extends through the kernel into
>> user space to the completion of the boot process. The timing starts when
>> the system leaves reset, not later when the kernel starts.
>> The bootstage record aims to provide 20-30 timestamps ranging from reset
>> to login prompt (or some other definition of completion).
>
> Any way to make this play nice with bootchart, which provides much finer
> detail records once userspace gets started?
>
> https://github.com/mmeeks/bootchart

It would be great to collect CPU utilization, disk activity, etc. in
the boot loader and the kernel start-up. I don't know if we have the
hooks for that though.  Everything seems to be based around user space
at the moment. Still, we could integrate in the sense that it could
show the various boot stages on the chart. Could be useful.

Regards,
Simon

>
>
>
