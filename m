Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab1FVJjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:39:10 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:41673 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1FVJjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:39:07 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lq2M7oEuo=
X-RZG-CLASS-ID: mo00
Date: Wed, 22 Jun 2011 11:39:03 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] panic: panic=-1 for immediate reboot
Message-ID: <20110622093903.GA1981@aepfle.de>
References: <1308612129-12488-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1308612129-12488-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, Mandeep Singh Baines wrote:

> From: Hugh Dickins <hughd@chromium.org>
> 
> When kernel BUG or oops occurs, ChromeOS intends to panic and immediately
> reboot, with stacktrace and other messages preserved in RAM across reboot.
> But the longer we delay, the more likely the user is to poweroff and lose
> the info.

I have no strong opinion here, but:

Is delaying one second (instead of say 180 like on powerpc) such a big
deal if the system is dead anyway?

Olaf
