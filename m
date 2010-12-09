Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0LIO1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 09:27:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:47870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab0LIO1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 09:27:35 -0500
Message-ID: <4D00E74B.3030401@kernel.org>
Date: Thu, 09 Dec 2010 15:27:23 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1 000/211] unicore32 architecture support
References: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn> <4D00A672.9050906@kernel.org> <alpine.LFD.2.00.1012091443580.2653@localhost6.localdomain6> <4D00E212.9080001@kernel.org> <alpine.LFD.2.00.1012091516240.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012091516240.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 14:27:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 03:18 PM, Thomas Gleixner wrote:
> It's not a question of merging. It's a question of reviewing and I've
> done quite a bunch of reviews on new archs, so I know what I'm talking
> about. Reviewing a single patch with everything and the world included
> is just not workable.

Sure, I agree the per-topic patch series would be much better for
reviewing.  Then, just make _that_ point.  Don't go to the opposite
extreme and claim unthreaded per-file 200+ patches in whatever order
are better as that's painful for everyone on the mailing list.

Thanks.

-- 
tejun
