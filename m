Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab2H0UQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:16:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35847 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab2H0UQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:16:32 -0400
Message-ID: <503BD597.3070400@zytor.com>
Date: Mon, 27 Aug 2012 13:16:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Yinghai Lu <yinghai@kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com> <1345852516-3125-4-git-send-email-jacob.shin@amd.com> <CAE9FiQUjaBSn0q=+om7+CPjLXVD9Pemf=mNvgYG7C3bE5XxOSw@mail.gmail.com> <20120825042409.GD26127@jshin-Toonie> <CAE9FiQX2DApN=OU=xTK3VA+p1mDJ=U+qFyyRkaeTiH+xF5dQXw@mail.gmail.com> <20120827184912.GA23135@jshin-Toonie>
In-Reply-To: <20120827184912.GA23135@jshin-Toonie>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 11:49 AM, Jacob Shin wrote:
> 
> Yinghai, another question, what about hotplug? Are we guaranteed that
> we will always be adding memory above max_pfn_mapped?

I don't think we can rely on this...

> And hotplug will also update e820 to mark the range as E820_RAM as well?

This is really should.

	-hpa

