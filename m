Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1B1T67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:58:59 -0500
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:49883 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab1B1T66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:58:58 -0500
Message-ID: <4D6BFE7D.9000907@ece.ntua.gr>
Date: Mon, 28 Feb 2011 21:58:53 +0200
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110225 Lightning/1.0b3pre Lanikai/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        psomas@cslab.ntua.gr
Subject: Re: [PATCH 0/2] x86_32 cleanup: KERNEL_IMAGE_SIZE
References: <1298841698-31823-1-git-send-email-psomas@cslab.ece.ntua.gr>
In-Reply-To: <1298841698-31823-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (ulysses.noc.ntua.gr [147.102.222.230]); Mon, 28 Feb 2011 21:58:55 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2011 11:21 PM, Stratos Psomadakis wrote:
> I noticed that KERNEL_IMAGE_SIZE is no longer used by x86_32 code
> (head_32.S no longer uses it for the initial kernel mapping).
>
> We can thus remove the assert from the vmlinux.lds.S file, and 
> remove it completely for x86_32 code. 
>
> Since head_32.S doesn't use it anymore, I can't find a reason 
> why we should impose such a limit on the kernel image size
> (although a 512+MB kernel image isn't what one would call a realistic
> scenario :P)
>
> I think that a limit on the size of the image is imposed anyway
> by decompress_kernel()(if I understood correctly).
>
> I also updated the comments in head_32.S which still had references
> to KERNEL_IMAGE_SIZE.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
added cc, just in case anyone is interested

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

