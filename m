Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1IVTFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:05:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50505 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1IVTFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:05:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110922182048.GB4709@gere.osrc.amd.com>
References: <20110921235515.7476c5fe.lucasvr@gmail.com>
	<20110922092347.GD17640@liondog.tnic>
	<20110922171829.GA4863@suse.de>
	<20110922175406.GA4709@gere.osrc.amd.com>
	<20110922180327.GA1932@suse.de>
	<20110922182048.GB4709@gere.osrc.amd.com>
Date: Thu, 22 Sep 2011 16:05:45 -0300
X-Google-Sender-Auth: o7qtP-XccTWZgSDXma4nIOvsJc0
Message-ID: <CAAvzgtZ3aWjpN++3qo1LCS9A+GsNzbnG0vEDqyDG8OHYJeXwuA@mail.gmail.com>
Subject: Re: [PATCH] Initialize pointer on request_firmware
From: "Lucas C. Villa Real" <lucasvr@gobolinux.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Wey-Yi Guya <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 3:20 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Sep 22, 2011 at 11:03:27AM -0700, Greg KH wrote:
>> The patch was in the 2.6.36 kernel, so by nature of that, 3.0 will also
>> have it, right?
>
> Ok, a colleague of mine gave me 3.0.4 to stare at - and you're right
> the patch is there. So what is still missing is caca9510ff4e5 from
> upstream which reroutes the exit path so that firmware_p is NULLed
> before returning -EBUSY.
>
> Lucas, can you apply caca9510ff4e5 from upstream and verify it fixes the
> issue for ya?

Sure. I'll do that tonight and will let you now -- the laptop I'm
using right now doesn't suffer from that problem.

Thanks,

-- 
Lucas
"If you're looking for a reason I've a reason to give: pleasure,
little treasure"
