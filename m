Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1GIIm6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 04:42:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58937 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab1GIIm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 04:42:57 -0400
Message-ID: <4E181477.5090405@zytor.com>
Date: Sat, 09 Jul 2011 01:42:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Conny Seidel <conny.seidel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: Re: [PATCH x86/urgent 2/2] x86: Implement pfn -> nid mapping granularity
 check
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com> <20110626102235.GC12200@mtj.dyndns.org> <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com> <20110628174613.GP478@escobedo.osrc.amd.com> <20110629094451.GJ3386@htj.dyndns.org> <20110701162239.GX3386@htj.dyndns.org> <20110701162327.GY3386@htj.dyndns.org> <20110709083206.GB943@htj.dyndns.org>
In-Reply-To: <20110709083206.GB943@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2011 01:32 AM, Tejun Heo wrote:
> 
> Ping?  If the change is too invasive at this stage, we can disable AMD
> NUMA on x86_32 for 3.0 and queue these two for 3.1.
> 

I am kind of leaning that way... Hans, what is your opinion?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

