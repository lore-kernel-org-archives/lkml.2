Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2E3PDC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:03:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39209 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab2E3PDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:03:00 -0400
Message-ID: <4FC6363F.3040208@zytor.com>
Date: Wed, 30 May 2012 08:01:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andre Przywara <andre.przywara@amd.com>,
        mingo@elte.hu, tglx@linutronix.de, konrad.wilk@oracle.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, stable@vger.kernel.org.#.3.4+
Subject: Re: [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com> <4FC631D3.9080907@zytor.com> <20120530145523.GA15635@x1.osrc.amd.com> <4FC6358F.2010405@zytor.com> <20120530150007.GB15438@x1.osrc.amd.com>
In-Reply-To: <20120530150007.GB15438@x1.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 08:00 AM, Borislav Petkov wrote:
> On Wed, May 30, 2012 at 07:58:23AM -0700, H. Peter Anvin wrote:
>> If so, then fix the description to match reality and we can take the patch.
> 
> Andre, would you please do that?
> 

Ah, but now we get:

>> I'm not following: If the AMD variants (putting a special value into
>> %edi) can be freely replaced by the non-AMD variants, why did
>> the AMD special ones get used in the first place?

> Older CPUs (K8) needed the AMD variants, starting with family 10h we
> can use the normal versions.

So no, not correct.

	-hpa


