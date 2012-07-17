Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2GQQ5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:57:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57733 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2GQQ5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:57:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120717162437.GA6049@thunk.org>
References: <CAFDTedp84TuxHpz2SJTG_jdjtkQ7r9qkCjqQWT5Zg22LrT7tTg@mail.gmail.com>
 <20120717135201.GF1638@fysh.org> <CAFDTedowCyNgBtiPQUPVUv1XocMEhQJfyawjYxEkaXFX5E8H1A@mail.gmail.com>
 <20120717162437.GA6049@thunk.org>
From: =?ISO-8859-1?B?QWRyaeFu?= <adrianbn@gmail.com>
Date: Tue, 17 Jul 2012 17:56:42 +0100
Message-ID: <CAFDTedoBOijJdw4zAEYgHzJL8GEoe32Uxy5Em-qaxqFFx0L2UQ@mail.gmail.com>
Subject: Re: Setreuid distinction about (uid_t)-1
To: "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?B?QWRyaeFu?= <adrianbn@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 5:24 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jul 17, 2012 at 03:13:18PM +0100, Adrián wrote:
>>
>> Thanks a lot Athanasius. What I still can't see is why is the -1
>> exception there, as I assume that if you want to leave one of the ids
>> unchaged you can call:
>>
>> setreuid(0,geteuid());
>>
>> If you want to leave euid unchanged, right? Is there a need or reason
>> to be doing this differentiation in the setreuid code?
>
> Unix systems for multiple decades have done things this way, and it's
> ensrined in POSIX and the Single Unix Specification.  Changing it
> would potentially open up security holes for programs which expect the
> standard-specificed behavior.
>
> (Note, BTW, that decades ago system calls weren't cheap, and CPU's
> were much slower, and that may have driven the historical behavior.
> Sometimes we get forget how spoiled we are that Linux's system call
> overhead is as low as it is...)
>
>                                         - Ted
Thanks for that Theo!
Adrian
