Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0KCQp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:45:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52207 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0KCQpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ElOgJD1Q/FU/6g4vn10kDcZl6TmBxFrpHTM9cQz2NafJbadzbZ5WZBRZIr5aKO+cM3
         FLOM9R1ohBpzjfaWJ4eltCDT3CxfFUkXzE6tbVmQXenmHfnIOUiaZHnsZAGxK7esO4Z4
         xfeoTXMssxSwyQDFAIQ5f7AC8a1Aint+uSeog=
Date: Thu, 4 Nov 2010 00:48:40 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: trapDoor <trapdoor6@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Pure kernel '2.6.37-rc1-00001-ge99d11d' shown as ~-dirty after
	compilation
Message-ID: <20101103164840.GC4683@hack>
References: <AANLkTik=04z2thHBS3Z9n68QnTs=i8g8qTFtNT3jb8cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik=04z2thHBS3Z9n68QnTs=i8g8qTFtNT3jb8cg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 08:26:59AM +0000, trapDoor wrote:
>,Hello,
>When I run 'make kernelrelease' on freshly cloned Linus' git tree it
>shows kernel version as: '2.6.37-rc1-00001-ge99d11d' - and that's
>correct.
>But after compilation it turned up '2.6.37-rc1-00001-ge99d11d-dirty'.
>
>I didn't apply any custom patches to my local tree between 'make
>kernelrelease' and compilation. What I only added - and before running
>'make kernelrelease' - were the following Radeon firmware blobs for my
>graphic card, which I placed in <kernel-source>/firmware/radeon/, in
>order to compile them in:
>REDWOOD_me.bin
>REDWOOD_pfp.bin
>REDWOOD_rlc.bin
>
>That's how I always did and none of the git-kernels I compiled before
>was referred to as '-dirty' due to the firmware blobs added manually.
>Also, the kernel version shown by 'make kernelrelease' never differed
>from the final kernel version after compilation. Of course assuming
>that no patches were applied in the meantime and no extra string was
>appended manually to the kernel version.
>
>So, what's this '-dirty' about?
>

That means your git tree is not clean, since you placed new firmwares
into the source tree.

-- 
Live like a child, think like the god.
 
