Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1GPH5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 03:57:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1GPH5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 03:57:06 -0400
Date: Sat, 16 Jul 2011 09:56:00 +0200
From: Greg KH <gregkh@suse.de>
To: "Ted Ts'o" <tytso@mit.edu>, Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Message-ID: <20110716075600.GA17945@suse.de>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <20110714212113.GA28639@suse.de>
 <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
 <20110715064147.GA1021@suse.de>
 <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
 <20110715145132.GA4296@suse.de>
 <20110715185519.GI8453@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715185519.GI8453@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 02:55:19PM -0400, Ted Ts'o wrote:
> On Fri, Jul 15, 2011 at 04:51:32PM +0200, Greg KH wrote:
> > 
> > But none of them are on the Signed-off-by: line area, right?
> 
> Is it really the case that your concern is that there be a whitespace
> between the bug tracker reference and the signed-off-by area?   So
> 
>      Company-bug-id: ....
> 
>      Signed-off-by: ....
> 
> is preferable to
> 
>      Company-bug-id:
>      Signed-off-by: ...
> 
> If that's your only concern, ok, whatever.  I don't personally care a
> whole lot either way.
> 
> It's not like there was ever any kind of formal standards committee
> that decided that adding "Acked-by" and "Tested-by" and "CC" were ok
> in the signed-off-by block, and other things weren't, after all.

But those were agreed apon, and standardized on, and look, documented,
as to how to use them.

If you want to propose, and document, using "Company-bug-id", that's
great, and is valid, but don't try to slip things in like this, with a
company specific name, into the standardized tag area and claim it is
acceptable after the fact.

Again, I think people here are somehow forgetting the 300+ different
companies that contribute to the kernel...

greg k-h
