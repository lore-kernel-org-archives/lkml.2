Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0ITPLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:11:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36965 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632Ab0ITPLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:11:16 -0400
Message-ID: <4C977979.2060301@zytor.com>
Date: Mon, 20 Sep 2010 08:10:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86, cpuid: Unbreak CPB CPUID feature
References: <20100920140521.GA4823@aftab>
In-Reply-To: <20100920140521.GA4823@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 07:05 AM, Borislav Petkov wrote:
> 5958f1d5d722df7a9e5d129676614a8e5219bacd added mistakenly the CPB bit to
> the common scattered CPUID features. Move it to AMD-only code where it
> belongs.

I already asked for more information about this.  This patch, without a
further description, makes absolutely no sense, and is furthermore
implemented poorly -- I really don't want more ad hoc code if it can be
avoided.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

