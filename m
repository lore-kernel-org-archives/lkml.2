Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1GOSzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:55:35 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:51188 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1GOSze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:55:34 -0400
Date: Fri, 15 Jul 2011 14:55:19 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Greg KH <gregkh@suse.de>
Cc: Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Message-ID: <20110715185519.GI8453@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
	Mike Waychison <mikew@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <20110714212113.GA28639@suse.de>
 <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
 <20110715064147.GA1021@suse.de>
 <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
 <20110715145132.GA4296@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715145132.GA4296@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 04:51:32PM +0200, Greg KH wrote:
> 
> But none of them are on the Signed-off-by: line area, right?

Is it really the case that your concern is that there be a whitespace
between the bug tracker reference and the signed-off-by area?   So

     Company-bug-id: ....

     Signed-off-by: ....

is preferable to

     Company-bug-id:
     Signed-off-by: ...

If that's your only concern, ok, whatever.  I don't personally care a
whole lot either way.

It's not like there was ever any kind of formal standards committee
that decided that adding "Acked-by" and "Tested-by" and "CC" were ok
in the signed-off-by block, and other things weren't, after all.

       		     	    	      	     	      - Ted
