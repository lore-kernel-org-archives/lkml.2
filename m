Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2FOVxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:53:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40172 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab2FOVxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:53:14 -0400
Date: Fri, 15 Jun 2012 14:53:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Kay Sievers <kay@vrfy.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120615215309.GA28221@kroah.com>
References: <1336004953.4240.9.camel@mop>
 <20120526111143.GA32304@lizard>
 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
 <1338307620.886.21.camel@mop>
 <20120615000422.GA8591@kroah.com>
 <1339762071.2050.20.camel@foo>
 <20120615122311.GD28541@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615122311.GD28541@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:23:11PM +0200, Ingo Molnar wrote:
> 
> * Kay Sievers <kay@vrfy.org> wrote:
> 
> > On Thu, 2012-06-14 at 17:04 -0700, Greg KH wrote:
> > 
> > > As no one seems to have responded, care to resend this with a
> > > signed-off-by so I can queue it up for 3.6?  If people complain, it can
> > > still go to 3.5, but given that no one is saying anything, I guess no
> > > one cares...
> > 
> > Sounds like a good plan. Here it is.
> > 
> > Thanks,
> > Kay
> > 
> > 
> > From: Kay Sievers <kay@vrfy.org>
> > Subject: kmsg - kmsg_dump() use iterator to receice log buffer content
> 
> typo.
> 
> > 
> > Provide an iterator to receive the log buffer content, and convert all
> > kmsg_dump() user to it.
> 
> typo.

<snip>

Thanks, I've fixed up all of these typos in the patch before I applied
it.

We need a "Proofread-by:" tag :)

greg k-h
