Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2CLRsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:48:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab2CLRsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:48:11 -0400
Date: Mon, 12 Mar 2012 13:48:03 -0400
From: Dave Jones <davej@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: snd_pcm lockdep report from 3.3-rc6
Message-ID: <20120312174803.GA1946@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Takashi Iwai <tiwai@suse.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120312143514.GA1881@redhat.com>
 <s5hfwdd3ecn.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfwdd3ecn.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 06:42:48PM +0100, Takashi Iwai wrote:

 > No, the check above should be correct.  The code tries to re-lock when
 > the stream is linked like group-lock -> stream-lock.
 > 
 > However, that code is known to be too tricky and messy for long time.
 > It'd be really better to get rid of this complexity.  I tried some
 > times but failed to reach to the final goal due to lack of time.
 > 
 > OK, let me respin my old patch.  The refreshed one is attached below.
 > (Note that it's totally untested.  I have to leave my office now,
 >  sorry for that.  Let me know if the wonder happens and it works :)

it certainly makes the code look a little simpler!
I'll run with it for a while, and see if anything falls out.

thanks,

	Dave
