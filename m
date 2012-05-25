Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab2EYAzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 20:55:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58027 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365Ab2EYAzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 20:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <4FBED482.4050800@zytor.com>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk> <1337875681-20717-1-git-send-email-wad@chromium.org>
 <alpine.LRH.2.02.1205250932270.26644@tundra.namei.org> <CAObL_7GHEdoyzVPjhR5U0RvQhRP50e6YM83CkXifzUKOFb+KHQ@mail.gmail.com>
 <4FBECAC2.6050303@zytor.com> <CAObL_7GSNbgceHQpNx3fbiCbV5u-_vJJO5cptwVCK34W7wFH5Q@mail.gmail.com>
 <4FBED482.4050800@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 24 May 2012 17:55:02 -0700
X-Google-Sender-Auth: OJRo3ugbiLVw60UPbVbiHCdTBM8
Message-ID: <CAObL_7GKUQ0TdGtbJj39oVZPGVwa7dwWAfHXj=r9G6o2fMAshg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] move the secure_computing call
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Morris <jmorris@namei.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, mcgrathr@google.com, indan@nul.nu,
        netdev@parisplace.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        serge.hallyn@canonical.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 5:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/24/2012 05:26 PM, Andrew Lutomirski wrote:
>>
>> Just to clarify: are you suggesting that, for now, the traced behavior
>> should be:
>>
>> process -> seccomp -> ptrace -> kernel?
>>
>> If so, I think the man page or something should have a big fat warning
>> that seccomp filters should *never* allow ptrace (even PTRACE_TRACEME)
>> unless they fully understand the issue.
>>
>
> Yes, and yes.
>
>> In any case, I think that the UML interaction is missing the point.
>> UML will *emulate* the seccomp filter.  If it chooses to use host
>> seccomp filters for some business, that's its business.
>
> I don't see why UML should have to emulate the seccomp filter.  With the
> proposed order, then it can simply use the seccomp filter provided by
> the host.  Furthermore, with this sequencing UML can actually *use*
> seccomp to provide the simulation.

Hmm.  I guess I agree.  I'll shut up now :)

--Andy
