Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab1GNWk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:40:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46030 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab1GNWk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:40:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Tw3ml3smYrx+mcznHJ1+GvtmKpVOzS4IWnVfH/h3fvwvBCPZs6sztm93AbqjNmEJb
	jXu2G5UfEexC0Cl0gK0hA==
MIME-Version: 1.0
In-Reply-To: <4E1F6F32.7040504@zytor.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <1310675693-9204-2-git-send-email-mikew@google.com> <20110714153113.31ffdeea.akpm@linux-foundation.org>
 <4E1F6F32.7040504@zytor.com>
From: Mike Waychison <mikew@google.com>
Date: Thu, 14 Jul 2011 15:40:03 -0700
Message-ID: <CAGTjWtCL-4kqHdQsKHTwCC58y9nqHsJXqxpyygRi3qFvUsqVWw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 3:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/14/2011 03:31 PM, Andrew Morton wrote:
>>
>> sys_iopl() is missing asmlinkage.
>>
>> It would be far more conventional to use cond_syscall().  Perhaps by
>> adding a CONFIG_X86 area into kernel/sys_ni.c
>>
>> fyi, I'm offering special deals on checkpatch.pl site licenses this month.
>
> Again, I don't think this makes sense as a compile-time-only option.

echo "enabled" > /proc/sys/kernel/iopl_available
echo "disabled" > /proc/sys/kernel/iopl_available
echo "locked" > /proc/sys/kernel/iopl_available

?
