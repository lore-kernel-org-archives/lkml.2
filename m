Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab2HYBNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 21:13:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab2HYBNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 21:13:14 -0400
Message-ID: <5038269E.80707@zytor.com>
Date: Fri, 24 Aug 2012 18:13:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com> <1345852516-3125-4-git-send-email-jacob.shin@amd.com> <50381C9D.5070007@zytor.com> <20120825004859.GB10812@jshin-Toonie>
In-Reply-To: <20120825004859.GB10812@jshin-Toonie>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 05:49 PM, Jacob Shin wrote:
> 
> Right, I think what I was attempting to do was to merge the 1MB
> with E820_RAM right above 1MB:
> 
> So instead of:
> 
> init_memory_mapping(0, 1MB)
> init_memory_mapping(1MB, 2GB)
> 
> It would be:
> 
> init_memory_mapping(0, 2GB)
> 
> While taking care of the odd case where there is a gap right after
> 1MB.
> 
> But if its not worth it, I can move it out of the loop.
> 

What is the benefit?

	-hpa

