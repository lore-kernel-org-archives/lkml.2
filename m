Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab2BQELa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 23:11:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37015 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab2BQEKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 23:10:53 -0500
Message-ID: <4F3DD30A.6030008@zytor.com>
Date: Thu, 16 Feb 2012 20:09:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, keescook@chromium.org
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
References: <1329422549-16407-1-git-send-email-wad@chromium.org>    <1329422549-16407-3-git-send-email-wad@chromium.org>    <4F3D61CB.2000301@zytor.com>    <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com>    <4F3D7250.6040504@zytor.com>    <501858544d264abc6526f2b25a224f2b.squirrel@webmail.greenhost.nl>    <4F3DAE5D.3080000@zytor.com>    <f2d1a14c965cea740d688c574c6006bb.squirrel@webmail.greenhost.nl>    <CAObL_7GUTbc=Ew9mQw7CoWfdAfRWSWUrY3w+UnrYrqWEiHxtcQ@mail.gmail.com>    <4F3DB9E8.7040406@zytor.com> <b33f697878e9b601d1d9bddfbf7a61cb.squirrel@webmail.greenhost.nl>
In-Reply-To: <b33f697878e9b601d1d9bddfbf7a61cb.squirrel@webmail.greenhost.nl>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 07:27 PM, Indan Zupancic wrote:
> 
> A JIT won't be able to merge accesses because it also has to merge other
> instructions and recognize when 64-bit operations are done with 32-bit
> instructions. I think that will be too hard for a JIT.
> 

Please Google "peephole optimizer".

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

