Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1GOPUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:20:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab1GOPUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:20:30 -0400
Date: Fri, 15 Jul 2011 17:19:16 +0200
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@MIT.EDU>, Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Message-ID: <20110715151916.GC4747@suse.de>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <20110714212113.GA28639@suse.de>
 <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
 <20110715064147.GA1021@suse.de>
 <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
 <20110715145132.GA4296@suse.de>
 <20110715155835.4e019ca5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715155835.4e019ca5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 03:58:35PM +0100, Alan Cox wrote:
> > But none of them are on the Signed-off-by: line area, right?
> 
> We have a fair number of people using things like
> 
> Fixes-bug: [URL]
> 
> 
> Its useful public info, it makes it easier to grep

That's fine, but that is not what was done here.  And those URLs had
better be public as well.

greg k-h
