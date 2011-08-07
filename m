Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1HGPpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 11:45:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56019 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab1HGPpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 11:45:01 -0400
Date: Sun, 7 Aug 2011 17:44:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC v2] x86-64: Allow emulated vsyscalls from user addresses
Message-ID: <20110807154456.GA695@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrew Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, lueckintel@yahoo.com,
	kimwooyoung@gmail.com, Suresh Siddha <suresh.b.siddha@intel.com>
References: <4E3C8B8A.3080007@zytor.com>
 <44eea096d708c5c3273e41ced354073ebd62a1d6.1312599769.git.luto@mit.edu>
 <20110806064552.GA13220@elte.hu>
 <20110807121913.GA7007@liondog.tnic>
 <CAObL_7Et-CcamO+X4D5tvH3oWh9=Zog0t=MzOnyqNPzmGqmm2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAObL_7Et-CcamO+X4D5tvH3oWh9=Zog0t=MzOnyqNPzmGqmm2A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 07, 2011 at 08:58:56AM -0400, Andrew Lutomirski wrote:
> > Also, what do we do with userspace which decides to hardcode "int 0x4[012]"
> > somewhere in the meantime?
> 
> Break it?  Any code that does that will get an unconditional warning
> with this patch.

Ok, I hope you're right. Because I'm sure you remember the last
prominent time the kernel broke userspace in the face of powertop.
Although having the warning should be fine, i.e. along the lines of "you
silly userspace process have been warned."

Thanks.

-- 
Regards/Gruss,
    Boris.
