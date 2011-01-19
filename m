Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1ASHjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 02:39:09 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:40859 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1ASHjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 02:39:08 -0500
Date: Wed, 19 Jan 2011 08:39:05 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
Message-ID: <20110119073905.GA1652@gentoo.trippels.de>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.01.18 at 15:54 -0800, Linus Torvalds wrote:
> 
> And as usual, report any regressions to the lists and the appropriate
> authorities.

Unfortunately 2.6.38-rc1 doesn't even boot on my machine (amd64).
This is caused by 86b1e8dd83cbb0f:
    x86: Make relocatable kernel work with new binutils

Reverting the commit solves the problem.

-- 
Markus
