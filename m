Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1JKPqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:46:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54235 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab1JKPqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:46:22 -0400
References: <1318337645-7112-1-git-send-email-matt@console-pimps.org> <20111011130333.GA4117@srcf.ucam.org> <1318338617.4060.109.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1318338617.4060.109.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86, efi: Calling __pa() with an ioremap'd address is invalid
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Tue, 11 Oct 2011 08:45:38 -0700
To: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <ming@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>
Message-ID: <df88dc7c-e404-4190-a15c-4c3ef44ed45f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think ioremap_cache() should work for either.

Matt Fleming <matt@console-pimps.org> wrote:

>On Tue, 2011-10-11 at 14:03 +0100, Matthew Garrett wrote:
>> Is there any chance of unifying the 32 and 64-bit code here as well?
>
>I was under the impression that this wasn't possible for the cached
>case
>because the 32-bit code path uses ioremap_cache() whereas 64-bit uses
>init_memory_mapping() and __va().
>
>Unless I'm missing something?

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
