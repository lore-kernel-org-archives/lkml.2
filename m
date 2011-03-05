Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1CECpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 21:45:25 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:6582 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752049Ab1CECpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 21:45:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAPIycU1Ld/sX/2dsb2JhbAAMhB3RAZA8gSeDRHYEhRw
X-IronPort-AV: E=Sophos;i="4.62,267,1297054800"; 
   d="scan'208";a="94469735"
Message-ID: <4D71A3BB.40108@teksavvy.com>
Date: Fri, 04 Mar 2011 21:45:15 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: Scott James Remnant <scott@netsplit.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ken Sumrall <ksumrall@android.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
References: <1299137483-10975-1-git-send-email-ksumrall@android.com>	<AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>	<4D6FDDB1.3060209@teksavvy.com>	<AANLkTimXhGRsuL3Z51msS_YEtsa4UZuN9XW8Xb+hu_KN@mail.gmail.com>	<AANLkTinQ30f-7bi8QSBjwcmHXH6aydqws1vrFMMaMCWc@mail.gmail.com>	<AANLkTi=UuVxtvLqWq=8gTGQyoNKmJwvs3Kr=xSWHbxtx@mail.gmail.com>	<4D7052E5.9030506@teksavvy.com> <AANLkTinb01zP9kj4ULwqoSHFrkRKA=K9DDG66ndtw-UP@mail.gmail.com>
In-Reply-To: <AANLkTinb01zP9kj4ULwqoSHFrkRKA=K9DDG66ndtw-UP@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-03 09:55 PM, Scott James Remnant wrote:
>
> Oddly enough I don't see any bugs filed by you about startup issues?
> Now, don't get me wrong, I'm not saying Ubuntu is perfect here - but
> I'm not aware of any races that are Upstart's fault. If there are,
> please file bugs! How else am I to fix them if I don't know about
> them?


Oddly enough, I used to file bugs quite diligently against distros.
Not one of them was ever investigated or fixed.

Instead, I would get an automated email with each subsequent re-release
of the buggy software, inviting me to further waste my time by resubmitting
the bug report should it still be present.

So.. I simply don't bother now.

And upstart is used for shutdown of at least some services on Ubuntu.
I just wish they'd THINK about sequences.. like umounting NFS
before killing the network devices, or stopping mythbackend
before killing mysql etc..

If I could figure out how to fix their .conf files, I would.

Cheers
