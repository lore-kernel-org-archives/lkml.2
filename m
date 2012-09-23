Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2IWRo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 13:44:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43116 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab2IWRo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 13:44:56 -0400
Message-ID: <505F4A85.6050403@zytor.com>
Date: Sun, 23 Sep 2012 10:44:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 0/4] devpts: fix devpts mount behavior
References: <20120124000517.GA28878@sergelap> <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com> <20120124002555.GA29534@sergelap> <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com> <20120124010758.GJ23916@ZenIV.linux.org.uk> <m1k44gj1cu.fsf@fess.ebiederm.org> <20120124220247.GA26353@hallyn.com> <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com> <20120124231601.GA4470@sergelap> <CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com> <20120128195103.GA11299@sergelap> <87txup763i.fsf_-_@xmission.com> <505F3D48.7080103@zytor.com> <87txuo3abb.fsf@xmission.com>
In-Reply-To: <87txuo3abb.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2012 10:42 AM, Eric W. Biederman wrote:
>
>> Greg, Kay, any idea how to make ptmx show up in devtmpfs as a symlink
>> to pts/pmtx instead of as a device node?
>
> The conversation stalled in January with that very question.
>
> What I am proposing doesn't conflict with any effort like that.
>

I just looked at the archive, and it apparently really comes down to 
"noone wants to take responsibility for it".  The real problem appears 
to be that with devtmpfs device name policy is actually split between 
user space and kernel, which is the worst possible configuration.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

