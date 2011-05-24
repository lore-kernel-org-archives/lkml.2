Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab1EXTGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:06:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58332 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755273Ab1EXTGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:06:50 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX18GdO0a/AYGpDBzBb5jw4krw5B3mMzSWkbgSkEtDz
	Fwp99Lg5+Ok+2I
From: Emil Langrock <emil.langrock@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: (Short?) merge window reminder
Date: Tue, 24 May 2011 21:06:47 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-1-amd64; KDE/4.6.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
In-Reply-To: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105242106.47657.emil.langrock@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> PS. The voices in my head also tell me that the numbers are getting
> too big. I may just call the thing 2.8.0. And I almost guarantee that
> this PS is going to result in more discussion than the rest, but when
> the voices tell me to do things, I listen.

Correct :)

I would still prefer the version number change to something like 2011.0 - 
already proposed at http://kerneltrap.org/Linux/Kernel_Release_Numbering_Redux

I don't think that it is reasonable to say that it is bad because third party 
scripts would break - they would break anyway (I would bet that many of them 
don't expect to see 3.x anyway). And changing now to 3.0 and then incrementing 
the second one everytime for 10 years will also lead to something like 3.56.7. 
I would also say that defining the release number using the time of the merge 
window start/end is easy understandable. "2.6.40" would be the third 
development cycle this year aka v2011.2 or v2011.2.0 when the patchlevel 
should always be included.
-- 
Emil Langrock
