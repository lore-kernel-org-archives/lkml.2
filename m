Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2LLWY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:24:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53826 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab2LLWY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:24:27 -0500
Message-ID: <50C9040C.20708@zytor.com>
Date: Wed, 12 Dec 2012 14:24:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC GIT PULL] "Nuke 386-DX/SX support" changes for v3.8
References: <20121211111026.GA26507@gmail.com> <CA+55aFzJX-EKC4Z98+KEaca0V27p8PxqZXiPox=TuuhytUTziw@mail.gmail.com> <50C8D458.4050006@zytor.com>
In-Reply-To: <50C8D458.4050006@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 11:00 AM, H. Peter Anvin wrote:
>
> It builds and boots, at least.  I'm currently installing Red Hat 4.1 in
> a VM so I can test to see if it does anything more than that.  It
> doesn't get in the way the same case the old 386 bits does, so I'm more
> reluctant to remove it, but it does touch a lot of paths.
>

Well... it turns out to boot and run Red Hat 4.1 just fine (using qemu 
-cpu 486 and the no387 option) once I changed /dev/hda1 to /dev/sda1.

I'm actually kind of impressed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

