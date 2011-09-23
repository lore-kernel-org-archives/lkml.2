Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab1IWIDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 04:03:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52355 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1IWIDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 04:03:20 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBQSBKS+bnLhStzV4PTrE+Qrb1XyeR5FEyn4d+NFZrhuOQ@mail.gmail.com>
References: <20110922123128.GA9761@quad>
	<CAOJsxLFDaYxevsH8UYEeZJrz7HCZSg89_XTaXP=hPTTG2HH9=w@mail.gmail.com>
	<CABPqkBQSBKS+bnLhStzV4PTrE+Qrb1XyeR5FEyn4d+NFZrhuOQ@mail.gmail.com>
Date: Fri, 23 Sep 2011 11:03:20 +0300
X-Google-Sender-Auth: BBNU-ZEhFDvLw7O_cuMwAkxM9YA
Message-ID: <CAOJsxLE1L1ffZmuF+2+vYZMTXyvq00pOcP1xvGJuW0TqxQskrA@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, robert.richter@amd.com,
        ak@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane!

On Fri, Sep 23, 2011 at 10:31 AM, Stephane Eranian <eranian@google.com> wrote:
>> So how important is this information? The output is going to be somewhat
>> awkward for very large CPU counts... :-)
>>
> It is useful to determine how CPUs share caches for instance.
> It can get large but large, but the meta-data header is not printed by
> default, you need to request it with the -I option.

Well, sure but it blocks rest of the interesting information too. It seems to me
that the CPU information could be truncated to some sane limit by default and
introduce a command line option for users that really want to see all of it.

We see patches to fix up kernel boot logs, for example, for this all the time
so it seems rather silly to make the same mistake for shiny new code, no?

                          Pekka
