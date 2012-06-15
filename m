Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2FOMZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:25:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50349 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab2FOMZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:25:11 -0400
Date: Fri, 15 Jun 2012 05:23:25 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120615122325.GA27129@lizard>
References: <1336004953.4240.9.camel@mop>
 <20120526111143.GA32304@lizard>
 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
 <1338307620.886.21.camel@mop>
 <20120615000422.GA8591@kroah.com>
 <1339762071.2050.20.camel@foo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339762071.2050.20.camel@foo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:07:51PM +0200, Kay Sievers wrote:
[...]
> From: Kay Sievers <kay@vrfy.org>
> Subject: kmsg - kmsg_dump() use iterator to receice log buffer content
> 
> Provide an iterator to receive the log buffer content, and convert all
> kmsg_dump() user to it.
> 
> The structured data in the kmsg buffer now contains binary data, which
> should no longer be copied verbatim to the kmsg_dump() users.
> 
> The iterator should provide reliable access to the buffer data, and also
> supports proper log line-aware chunking of data while iterating.
> 
> Signed-off-by: Kay Sievers <kay@vrfy.org>

Thanks Kay, it works!

Reported-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Tested-by: Anton Vorontsov <anton.vorontsov@linaro.org>
