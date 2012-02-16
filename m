Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2BPUH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:07:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34105 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab2BPUHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:07:25 -0500
Message-ID: <4F3D61CB.2000301@zytor.com>
Date: Thu, 16 Feb 2012 12:06:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.org,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        keescook@chromium.org
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
References: <1329422549-16407-1-git-send-email-wad@chromium.org> <1329422549-16407-3-git-send-email-wad@chromium.org>
In-Reply-To: <1329422549-16407-3-git-send-email-wad@chromium.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 12:02 PM, Will Drewry wrote:
> +
> +/* Format of the data the BPF program executes over. */
> +struct seccomp_data {
> +	int nr;
> +	__u32 __reserved[3];
> +	struct {
> +		__u32	lo;
> +		__u32	hi;
> +	} instruction_pointer;
> +	__u32 lo32[6];
> +	__u32 hi32[6];
> +};
>  

This seems more than a bit odd, no?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

