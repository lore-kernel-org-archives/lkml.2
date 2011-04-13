Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab1DMVu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:50:28 -0400
Received: from 8bytes.org ([88.198.83.132]:60469 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab1DMVu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:50:27 -0400
Date: Wed, 13 Apr 2011 23:50:25 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110413215025.GA18463@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA60C30.4060606@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 01:48:48PM -0700, Yinghai Lu wrote:
> -	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
> +	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<21);

Btw, while looking at this code I wondered why the 512M goal is enforced
by the alignment. Start could be set to 512M instead and the alignment
can be aper_size as it should. Any reason for such a big alignment?

	Joerg

P.S.: The box is still in the office, I will try this debug-patch
      tomorrow.

