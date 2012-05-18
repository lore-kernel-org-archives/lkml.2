Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2ERQfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:35:19 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62840 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933Ab2ERQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:35:12 -0400
MIME-Version: 1.0
In-Reply-To: <4FB67697.50904@zytor.com>
References: <4FB67146.9080804@zytor.com>
	<CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com>
	<CAMe9rOp-UoQFBvvorZA8-jBXk5JobkVa+trUH7ihHLxNyqMuWw@mail.gmail.com>
	<4FB67697.50904@zytor.com>
Date: Fri, 18 May 2012 09:35:11 -0700
Message-ID: <CAMe9rOqAJGemCiAebtYczqvV62J_cyZcZDDtkFZyLHPKZg1xqQ@mail.gmail.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 9:19 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/18/2012 09:16 AM, H.J. Lu wrote:
>>
>> Please verify that binutils 2.22.52.0.2 is broken
>> and binutils 2.22.52.0.1 is OK.
>>
>
> I believe Ingo is using 2.22.52.0.1, and it is most definitely not okay.
>
> <mingo> GNU ld version 2.22.52.0.1-5.fc17 20120131
> <mingo> gcc version 4.7.0 20120112 (Red Hat 4.7.0-0.6) (GCC)
>

In that case, both 2.22.52.0.1 and 2.22.52.0.2 are bad.

-- 
H.J.
