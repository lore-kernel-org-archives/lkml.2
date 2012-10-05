Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2JEA2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 20:28:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57541 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab2JEA2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 20:28:00 -0400
Message-ID: <506E2970.8050603@zytor.com>
Date: Thu, 04 Oct 2012 17:27:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Add myself as the SWIOTLB maintainer.
References: <1349365773-12073-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1349365773-12073-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 08:49 AM, Konrad Rzeszutek Wilk wrote:
> Now that I've an IA64 box on top of the other boxes
> (IBM with Calgary-X, Intel VT-d, AMD Vi, and AMD GART - that
> can use SWIOTLB as fallback) I can reliably do regression
> testing.
>
> CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> CC: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>   MAINTAINERS |    8 ++++++++
>   1 files changed, 8 insertions(+), 0 deletions(-)
>

Acked-by: "H. Peter Anvin" <hpa@zytor.com>


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

