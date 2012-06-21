Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab2FUSG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 14:06:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51567 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab2FUSGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 14:06:55 -0400
Message-ID: <4FE3628C.6000604@zytor.com>
Date: Thu, 21 Jun 2012 11:06:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
References: <20120621162807.3c621d46@endymion.delvare> <4FE34BCB.5050305@linux.intel.com> <20120621190743.2e6601f6@endymion.delvare>
In-Reply-To: <20120621190743.2e6601f6@endymion.delvare>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 10:07 AM, Jean Delvare wrote:
> 
> And FWIW, X86_FEATURE_DS has no user in the kernel. Doesn't look like a
> key feature to me, but maybe my view is biased...
> 

No, but apparently perfmon2 depends on it, in userspace, and it relies
on the string.

So this is a nonstarter.

	-hpa
