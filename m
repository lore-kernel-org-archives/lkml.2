Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1GOSLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:11:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38725 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1GOSLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:11:32 -0400
Message-ID: <4E2082A5.8090205@zytor.com>
Date: Fri, 15 Jul 2011 11:10:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
References: <1310675693-9204-1-git-send-email-mikew@google.com> <20110714212113.GA28639@suse.de> <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com> <20110715064147.GA1021@suse.de> <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu> <20110715145132.GA4296@suse.de> <20110715155835.4e019ca5@lxorguk.ukuu.org.uk> <20110715151916.GC4747@suse.de> <CAGTjWtDszSANuye-y9MxvwE781DkVetG4m7XsjYpyMVFDTE+6w@mail.gmail.com> <20110715170112.GA5771@suse.de> <CAGTjWtCzU7pzWM5Eq5bP27683-ysEpi-m3K015g2AMTr=pR+6Q@mail.gmail.com>
In-Reply-To: <CAGTjWtCzU7pzWM5Eq5bP27683-ysEpi-m3K015g2AMTr=pR+6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 10:51 AM, Mike Waychison wrote:
>>
>> Unless you feel we should come up with something like:
>>        Internal-reference-id: XXXXX
>> and use a general tag like that for all companies, please don't put
>> company-specific and internal references in a place where they will be
>> commited to the public tree.
> 
> I'd be fine with something like "Internal-reference-id".
> 

I would go even further, and do something like:

Patch-ID: <id@sender> ...

... if it has internal structure to the poster that would be up to them.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

