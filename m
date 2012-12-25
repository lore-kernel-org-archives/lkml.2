Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2LYBGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 20:06:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35166 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab2LYBGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 20:06:21 -0500
Message-ID: <50D8FBF9.6050509@zytor.com>
Date: Mon, 24 Dec 2012 17:06:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading ramdisk
 and bzImage above 4G
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <20121222024225.GG3468@phenom.dumpdata.com> <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com> <20121222132419.GB2936@phenom.dumpdata.com>
In-Reply-To: <20121222132419.GB2936@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 05:24 AM, Konrad Rzeszutek Wilk wrote:
>
> Interestingly enough I only see this on any AMD machine - different
> motherboards, different memory configurations.
>
> And also in a HVM guest running on an AMD machine. If it runs on Intel
> it works just fine.
>

Could this be the ljmpq problem that Borislav reported (Intel 
implemented ljmpq, AMD didn't, and I was tempted by a micro-optimization 
which broke AMD which made it into the patchset)?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

