Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab1ANAHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:07:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36987 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1ANAHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:07:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dCPoyM/RGla0bCx1WPOoxPj22khcj6jFoNI+z4TzxRUSO28oXbmUL4AXodg4nMZ86P
         kJ5TJHVPzzJ3wLTBpxYEf6TQhXxcl6SO2SsNecyYfyVxPAxrDMafbOTXEt9y8OeBOTIg
         QNAFJW2UmFwo0Y5kjKZKZmxkOByEmdr7FVtAM=
MIME-Version: 1.0
In-Reply-To: <AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com>
References: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
	<1294700597-24239-1-git-send-email-mikew@google.com>
	<20110111065540.GA16036@aftab>
	<AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com>
Date: Thu, 13 Jan 2011 16:07:11 -0800
X-Google-Sender-Auth: 0Ur6BzNaXf3S525JQWLFtiBApB4
Message-ID: <AANLkTikM4_xxenWhQ_R5i7V6zs3pP26nhJJnkv9-j9SJ@mail.gmail.com>
Subject: Re: [PATCH] x86: Add an option to disable decoding of MCE
From: Tony Luck <tony.luck@intel.com>
To: Mike Waychison <mikew@google.com>
Cc: Borislav Petkov <bp@amd64.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Duncan Laurie <dlaurie@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:56 AM, Mike Waychison <mikew@google.com> wrote:
> figured out how to replace them yet).  With almost every single kernel
> version bump we've had, we've found numerous places where strings in
> the logs have subtly changed, breaking our infrastructure :(  Finding
> these is a painful process and often shows up late in the deployment
> process.  This is disastrous to our deployment schedules as rebooting
> our number of machines, well, it takes a while...
>
> I'm sorry if this is tangential to your comment above, but I feel the
> need to have folks recognize that printk() is _not_ a good foundation
> on which to build automation.

Congratulations .... you made the lwn.net "quote of the week"
  http://lwn.net/Articles/421784

 - wider distribution of this wisdom is a very good thing.

-Tony
