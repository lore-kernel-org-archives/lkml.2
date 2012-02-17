Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2BQBLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:11:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36053 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab2BQBLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:11:18 -0500
Message-ID: <4F3DA901.8030609@zytor.com>
Date: Thu, 16 Feb 2012 17:10:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Indan Zupancic <indan@nul.nu>, Will Drewry <wad@chromium.org>,
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
References: <1329422549-16407-1-git-send-email-wad@chromium.org> <1329422549-16407-3-git-send-email-wad@chromium.org> <4F3D61CB.2000301@zytor.com> <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com> <4F3D7250.6040504@zytor.com> <501858544d264abc6526f2b25a224f2b.squirrel@webmail.greenhost.nl> <CAObL_7G7CvCVgjR-JYjNDi_Sy65UHXaqas4-sQCVej-4bX2PJA@mail.gmail.com>
In-Reply-To: <CAObL_7G7CvCVgjR-JYjNDi_Sy65UHXaqas4-sQCVej-4bX2PJA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 04:51 PM, Andrew Lutomirski wrote:
> 
> IMO the best solution is to have the One True Seccomp Filter Compiler
> (tm).  It would handle multiple namespaces, cross-arch differences,
> and such, and it would do it correctly.  It could live in the kernel
> tree.
> 
> Without something like that or an incredible amount of special care,
> actual portability is probably a pipe dream.
> 
> --Andy
> 

Seconded!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

