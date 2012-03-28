Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab2C1AvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:51:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51774 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab2C1AvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzq8NZ9rr9W7JU6MrkQkFaFdHWKGPMs0ABYSjawS-m4ig@mail.gmail.com>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
 <CABS55+D97mKFdQhGdAXjMGfyRiWd4Os8wfRq9YNa-FQAEQSR7Q@mail.gmail.com>
 <CA+55aFyVELrXO50pfbL-eH48K3_3noRkKMDCqTSVsuSQ0hHRWw@mail.gmail.com>
 <CAMzpN2hqay2h111C6pWw6VEBMLDfO_UF-Xf41M1x5ewp5K90yw@mail.gmail.com>
 <20120327050238.GA19496@redhat.com> <CAMzpN2juEfBPcq-wKsMOG1v3ii9PNCPW6y+sT-XXAPf1jdAvkw@mail.gmail.com>
 <CA+55aFzq8NZ9rr9W7JU6MrkQkFaFdHWKGPMs0ABYSjawS-m4ig@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Mar 2012 17:50:46 -0700
X-Google-Sender-Auth: di2177BOxUj32wkQ_nGOMSxAR-A
Message-ID: <CA+55aFwvxPHMDhx0=1=nxVJHXU6=nKS_+dvUN4nA18ZXVqbV7Q@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
To: Brian Gerst <brgerst@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Jason Garrett-Glaser <jason@x264.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 5:39 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll test the current -git kernel on a F16 machine I have, just to
> check. But I'm also assuming that there is something specific about
> your setup, because otherwise I'd have expected many  more reports
> about this...

Confirmed. It's not something generic to F16, things work normally
here on the x86-64 machine I just checked on.

I wonder if maybe there's a testing snafu, and commit f132c5be05e4
wasn't in the tree you tested. So please do double-check.

                        Linus
