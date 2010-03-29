Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0C2VFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:05:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56045 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0C2VFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:05:32 -0400
Message-ID: <4BB11605.4080405@zytor.com>
Date: Mon, 29 Mar 2010 14:05:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: Can not boot with CONFIG_NO_BOOTMEM=y on i686
References: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com> <21d7e9971003221844k6ce67f40k69981ff92f29f20b@mail.gmail.com>
In-Reply-To: <21d7e9971003221844k6ce67f40k69981ff92f29f20b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 06:44 PM, Dave Airlie wrote:
> 
> I had a similar issue today, wasted a morning try to get either -rc1
> or -rc2 to boot on my 32-bit desktop here,
> until I worked out that the default for this option is to be on.
> 
> I suggest CONFIG_NO_BOOTMEM be default n for now.
> 
> Not sure why it was merged as default y.
> 

Because it was only a "chicken bit" to allow for debugging in case/when
something broke (which it has, indeed, allowed.)

	-hpa

