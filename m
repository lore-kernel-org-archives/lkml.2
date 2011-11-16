Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab1KPLyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:54:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41387 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756126Ab1KPLys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:54:48 -0500
Date: Wed, 16 Nov 2011 11:54:35 +0000
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: naveen yadav <yad.naveen@gmail.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Crash when memset of shared mapped memory in ARM
Message-ID: <20111116115435.GI4942@mudshark.cambridge.arm.com>
References: <CAJ8eaTzOtgMzcZeRr6f=+WhtsykK1NZraOGBPoqGncwcAGcTyQ@mail.gmail.com>
 <20111116084547.GG9581@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116084547.GG9581@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Replying to Russell so as to lose the -request addresses)

On Wed, Nov 16, 2011 at 08:45:47AM +0000, Russell King - ARM Linux wrote:
> Please do not spam mailing lists -request addresses when you post.  The
> -request addresses are there for you to give the mailing list software
> _instructions_ on what to do with your subscription.  It is not for
> posts to the mailing list.

For what it's worth, I was brave/daft enough to compile and run the testcase
with an -rc1 kernel and Linaro 11.09 filesystem on the quad A9 Versatile
Express:

root@dancing-fool:~# ./yad
mmap: addr 0x20000000
root@dancing-fool:~# ./yad
shm_open: File exists
mmap: addr 0x20000000

Looks like I'm missing the fireworks, despite the weirdy MAP_SHARED |
MAP_FIXED mmap flags.

Will
