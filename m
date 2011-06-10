Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1FJIZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:25:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44641 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1FJIZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:25:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF1D4CD.2060202@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 17:24:45 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH 00/12] x86: minor cleanups/fixes for MCE codes (v2)
References: <4DEED509.1040504@jp.fujitsu.com> <20110608101957.GA11337@aftab>
In-Reply-To: <20110608101957.GA11337@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/08 19:19), Borislav Petkov wrote:
> Well, I can't say I'm crazy about the severities mechanism but I guess
> this is fine for a cleanup patchset. Btw, the problem of making the
> severities readable will come up again when we implement this into perf
> filters and the complexity will be moved into the filter function...
> 
> Other than that,
> 
> Reviewed-by: Borislav Petkov <bp@amd64.org>

Thank you again for your review!
I hope we do much better with the perf filter version.

Thanks,
H.Seto

