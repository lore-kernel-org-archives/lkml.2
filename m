Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2HMDY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 23:24:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43216 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab2HMDYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 23:24:55 -0400
Message-ID: <50287378.5090801@zytor.com>
Date: Sun, 12 Aug 2012 20:24:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Khalid Aziz <khalid.aziz@hp.com>
CC: Betty Dall <betty.dall@hp.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86, pci: Fix all early PCI scans to check the vendor
 ID first
References: <1344464246-14618-1-git-send-email-andi@firstfloor.org> <1344551691.10751.12.camel@ejdallLaptop> <50259FCE.4070205@zytor.com> <50287315.5010203@hp.com>
In-Reply-To: <50287315.5010203@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2012 08:23 PM, Khalid Aziz wrote:
>
> If that is the case, there is a problem in the original code in
> arch/x86/kernel/aperture_64.c.The original code already stops scanning
> functions the first time it finds an invalid PCI class:
>

Unless we can prove that that is invalid *for that specific case*, then 
it is definitely wrong, and yes, I have seen devices in the field with 
multiple, discontiguous functions.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

