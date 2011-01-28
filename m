Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1A1QRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:17:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1A1QRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:17:12 -0500
Date: Fri, 28 Jan 2011 17:16:57 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        =?utf-8?B?QUtQTeOAgA==?= <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 1/3] Fix splitting poisoned THP.
Message-ID: <20110128161657.GG16981@random.random>
References: <4D4259B0.6040902@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4259B0.6040902@np.css.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jin,

On Fri, Jan 28, 2011 at 02:52:48PM +0900, Jin Dongming wrote:
> +				/*
> +				 * FIXME: if splitting THP is failed, it is better
> +				 * to stop the following operation rather than
> +				 * causing panic by unmapping. System might survive
> +				 * if the page is freed later.
> +				 */

I don't think there would be panic by unmapping. But the page has
already been freed so there's no need to kill anything.

A part from this comment which I'm uncertain about the panic, this new
series looks good to me!

Thanks,
Andrea
