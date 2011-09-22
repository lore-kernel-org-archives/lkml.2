Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1IVSUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:20:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38838 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab1IVSUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:20:45 -0400
Date: Thu, 22 Sep 2011 20:20:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Greg KH <gregkh@suse.de>
Cc: "Lucas C. Villa Real" <lucasvr@gmail.com>, linux-kernel@vger.kernel.org,
        Wey-Yi Guya <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] Initialize pointer on request_firmware
Message-ID: <20110922182048.GB4709@gere.osrc.amd.com>
References: <20110921235515.7476c5fe.lucasvr@gmail.com>
 <20110922092347.GD17640@liondog.tnic>
 <20110922171829.GA4863@suse.de>
 <20110922175406.GA4709@gere.osrc.amd.com>
 <20110922180327.GA1932@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922180327.GA1932@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 11:03:27AM -0700, Greg KH wrote:
> The patch was in the 2.6.36 kernel, so by nature of that, 3.0 will also
> have it, right?

Ok, a colleague of mine gave me 3.0.4 to stare at - and you're right
the patch is there. So what is still missing is caca9510ff4e5 from
upstream which reroutes the exit path so that firmware_p is NULLed
before returning -EBUSY.

Lucas, can you apply caca9510ff4e5 from upstream and verify it fixes the
issue for ya?

Thanks.

-- 
Regards/Gruss,
Boris.
