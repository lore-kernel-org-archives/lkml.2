Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab1FAXDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 19:03:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53874 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab1FAXDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 19:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UC3WB2w9K1yghbZGUZYsbauEYN7rYVa0M1Cs1uy4xae8EKDHSHl9MxFvGSdy4F7BlJ
         T7fUZiGbDaEvqkWk2PpCXJAgs5mq6UayZRK6GscifrDCyYs7QglQyIhfYRRjp760cD8J
         89+Q90JUW7DX2iynWl10H+CiJLcWtmTzemm+M=
MIME-Version: 1.0
In-Reply-To: <20110601212330.GF19633@outflux.net>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
	<1306897845-9393-5-git-send-email-wad@chromium.org>
	<20110601212330.GF19633@outflux.net>
Date: Wed, 1 Jun 2011 18:03:01 -0500
Message-ID: <BANLkTin7BA_s1tDwLzor=pZFTQUv0ObFxA@mail.gmail.com>
Subject: Re: [PATCH v3 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Will Drewry <wad@chromium.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 4:23 PM, Kees Cook <kees.cook@canonical.com> wrote:
> Hi Will,
>
> Minor typo corrections below...
>
> On Tue, May 31, 2011 at 10:10:37PM -0500, Will Drewry wrote:
>>  Adds a text file covering what CONFIG_SECCOMP_FILTER is, how it is
>>  implemented presently, and what it may be used for.  In addition,
>>  the limitations and caveats of the proposed implementation are
>>  included.
>>
>> --- /dev/null
>> +++ b/Documentation/prctl/seccomp_filter.txt
>> @@ -0,0 +1,145 @@
>> ...
>> +certain subset of userland applications benefit by having a reduce set
>                                                               reduced
>
>> +of available system calls.  The reduced set reduces the total kernel
>
> Maybe "The resulting set reduces ... " ?

Cool - I'll clean it up in the next cut.

Thanks!
will
