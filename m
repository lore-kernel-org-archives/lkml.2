Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2IWQsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 12:48:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42629 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab2IWQsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 12:48:36 -0400
Message-ID: <505F3D48.7080103@zytor.com>
Date: Sun, 23 Sep 2012 09:48:08 -0700
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
References: <20120124000517.GA28878@sergelap> <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com> <20120124002555.GA29534@sergelap> <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com> <20120124010758.GJ23916@ZenIV.linux.org.uk> <m1k44gj1cu.fsf@fess.ebiederm.org> <20120124220247.GA26353@hallyn.com> <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com> <20120124231601.GA4470@sergelap> <CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com> <20120128195103.GA11299@sergelap> <87txup763i.fsf_-_@xmission.com>
In-Reply-To: <87txup763i.fsf_-_@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2012 08:47 PM, Eric W. Biederman wrote:
> Making /dev/ptmx a symlink sounds simple, but in practice no one could
> actually figure out how to make it happen.

This feels particularly ridiculous since udev now requires devtmpfs (as 
in it will no longer work without it), which means this is all done in 
the kernel, so we should just be able to fix this in the kernel.

Greg, Kay, any idea how to make ptmx show up in devtmpfs as a symlink to 
pts/pmtx instead of as a device node?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

