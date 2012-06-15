Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2FOBcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:32:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51376 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab2FOBcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:32:50 -0400
Date: Thu, 14 Jun 2012 18:31:05 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120615013104.GA27584@lizard>
References: <1336004953.4240.9.camel@mop>
 <20120526111143.GA32304@lizard>
 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
 <1338307620.886.21.camel@mop>
 <20120615000422.GA8591@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120615000422.GA8591@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 05:04:22PM -0700, Greg KH wrote:
[...]
> > Unlike the old logic, there are no stale pointers handed out to the
> > dumper, if case things get overwritten while a dump is in progress,
> > lines are not truncated or overwritten.
> 
> As no one seems to have responded, care to resend this with a
> signed-off-by so I can queue it up for 3.6?  If people complain, it can
> still go to 3.5, but given that no one is saying anything, I guess no
> one cares...

Well, I do care. Just didn't find time to test it. I'll try to speed
myself up.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
