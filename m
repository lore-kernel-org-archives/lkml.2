Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1KIRUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:20:04 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:43287 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751285Ab1KIRUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:20:02 -0500
Message-ID: <4EBAB5F7.80000@xenotime.net>
Date: Wed, 09 Nov 2011 09:18:47 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
In-Reply-To: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 06:10 PM, Linus Torvalds wrote:

> Which brings me to a question I already asked on G+ - do people really
> need the old-fashioned patches? The -rc1 patch is about 22MB gzip-9'd,
> and part of the reason is that all those renames cause big
> delete/create diffs. We *could* use git rename patches, but then you'd
> have to apply them with "git apply" rather than the legacy "patch"
> executables. But as it is, the patch is almost a third of the size of
> the tar-ball, which makes me wonder if there's even any point to such
> a big patch?

[email was too long/noisy, sorry for the delayed reply.]
[should I admit that I don't follow you on g+ ?]


Do you mean files like patch-3.2-rc1.gz or .bz2 or .xz?
Yes, I use them, but if I am the only user of them, I'll get over it.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
