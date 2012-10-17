Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2JQS0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:26:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35040 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab2JQS0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:26:16 -0400
Message-ID: <507EF833.8020001@zytor.com>
Date: Wed, 17 Oct 2012 11:25:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Shuah Khan <shuah.khan@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        shuahkhan@gmail.com, andreas.herrmann3@amd.com,
        borislav.petkov@amd.com
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
References: <6ec48b96-afab-4c8b-ab74-2c640c2a161b@blur> <8630fe28-0c1c-4f3a-90e1-df2d1b6615a6@blur> <1350409738.2785.30.camel@lorien2> <20121016182621.GA10857@jshin-Toonie>
In-Reply-To: <20121016182621.GA10857@jshin-Toonie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 11:26 AM, Jacob Shin wrote:
>
> Right, we are (AMD) thinking about the same thing .. how to backport to
> stable kernels of major enterprise OSes
>
> The simplest and the least disruptive solution would be to not map memory
> holes that occur above 4GB, it won't affect 32 bit kernels, and it won't
> touch legacy (under 4GB) area (ISA, the PCI MMIO region ..):
>
> https://lkml.org/lkml/2011/10/20/323
>
> HPA, it would be great if we can first get this patch upstream, and also
> into the stable trees .. and after that, we can work on getting Yinghai's
> mm refactoring in ..
>

Yes, that makes sense at this point.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

