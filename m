Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab1GOOvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:51:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1GOOvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:51:48 -0400
Date: Fri, 15 Jul 2011 16:51:32 +0200
From: Greg KH <gregkh@suse.de>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Message-ID: <20110715145132.GA4296@suse.de>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <20110714212113.GA28639@suse.de>
 <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
 <20110715064147.GA1021@suse.de>
 <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 09:13:27AM -0400, Theodore Tso wrote:
> 
> On Jul 15, 2011, at 2:41 AM, Greg KH wrote:
> 
> > 
> > Ok, but what happens if all 2000+ different companies start adding their
> > fields to the signed-off-by: area of the kernel for their internal
> > tracking systems?
> 
> That's been happening for a long time; there have been kernel patches
> referencing LTC, RHEL, and SLES bugzilla entries; many of those
> bug entries are not public so as not to reveal customer confidential
> information.   I've never seen anyone complain about that before.

But none of them are on the Signed-off-by: line area, right?

Also, putting it in the text of the changelog, with a url, is fine.  And
it had better be a public url, otherwise it makes no sense at all.  I've
seen many public SUSE and Ubuntu urls in changelog entries, any
non-public ones should not be in there at all.

Just like with gerrit ids in signed-off-by areas, references to internal
bugzilla entries, in the signed-off-by area, should not be there at all.

greg k-h
