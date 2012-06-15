Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2FOMXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:23:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62847 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab2FOMXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:23:16 -0400
Date: Fri, 15 Jun 2012 14:23:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120615122311.GD28541@gmail.com>
References: <1336004953.4240.9.camel@mop>
 <20120526111143.GA32304@lizard>
 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
 <1338307620.886.21.camel@mop>
 <20120615000422.GA8591@kroah.com>
 <1339762071.2050.20.camel@foo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339762071.2050.20.camel@foo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay@vrfy.org> wrote:

> On Thu, 2012-06-14 at 17:04 -0700, Greg KH wrote:
> 
> > As no one seems to have responded, care to resend this with a
> > signed-off-by so I can queue it up for 3.6?  If people complain, it can
> > still go to 3.5, but given that no one is saying anything, I guess no
> > one cares...
> 
> Sounds like a good plan. Here it is.
> 
> Thanks,
> Kay
> 
> 
> From: Kay Sievers <kay@vrfy.org>
> Subject: kmsg - kmsg_dump() use iterator to receice log buffer content

typo.

> 
> Provide an iterator to receive the log buffer content, and convert all
> kmsg_dump() user to it.

typo.

> +/**
> + * kmsg_dump_get_line - retrieve one kmsg log line
> + * @dumper: registered kmsg dumper
> + * @syslog: include the "<4>" prefixes
> + * @line: buffer to copy the line to
> + * @size: maximum size of the buffer
> + * @len: length of line placed into buffer
> + *
> + * Start at the beginning of the kmsg buffer, with the oldest kmsg
> + * record, and copy one record into the provided buffer.
> + *
> + * Consecutive calls will return the next available record moving
> + * towards the end of the buffer with the youngest messages.
> + *
> + * A return value of FALSE indicate that there are no more records to
> + * read.

typo.

> + *
> + * Start at the end of the kmsg buffer and fill the provided buffer
> + * with as many of the the *youngest* kmsg records that fit into it.
> + * If the buffer is large enough, all available kmsg records will be
> + * copied with a single call.
> + *
> + * Consecutive calls will fill the buffer with the next block of
> + * available older records, not including the earlier retrieved ones.
> + *
> + * A return value of FALSE indicate that there are no more records to
> + * read.

typo.

Thanks,

	Ingo
