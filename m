Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab1GNWRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:17:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37677 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1GNWRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:17:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=w8stK9/nGNSIOLe7j7AJOFr8NDD1YGJcYfrYEEgaTDgCo92wocmeYVkMxHW9MBeaq
	XPyyaVXibFZz9u9o+hlbA==
MIME-Version: 1.0
In-Reply-To: <20110714212113.GA28639@suse.de>
References: <1310675693-9204-1-git-send-email-mikew@google.com> <20110714212113.GA28639@suse.de>
From: Mike Waychison <mikew@google.com>
Date: Thu, 14 Jul 2011 15:17:24 -0700
Message-ID: <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 2:21 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Jul 14, 2011 at 01:34:52PM -0700, Mike Waychison wrote:
>> It would be useful to build kernels with disabled support of /dev/port
>> for systems where we do not want to allow an administrator to access IO
>> ports directly.
>>
>> To do so however, CONFIG_DEVPORT needs to be user-selectable.  Give this
>> configuration option a name and help description.
>>
>> Google-Bug-Id: 3177114
>
> What is that field?  It's not something that I've ever seen before...

This is for our internal reference.

>
> Please don't push internal fields like this to public patches, it only
> causes confusion...

It hasn't caused any problems so far.  It helps us track things as we
pull code back downstream.
