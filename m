Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1JKNKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:10:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57836 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997Ab1JKNKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:10:19 -0400
Subject: Re: [PATCH] x86, efi: Calling __pa() with an ioremap'd address is
 invalid
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <ming@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>
In-Reply-To: <20111011130333.GA4117@srcf.ucam.org>
References: <1318337645-7112-1-git-send-email-matt@console-pimps.org>
	 <20111011130333.GA4117@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 14:10:17 +0100
Message-ID: <1318338617.4060.109.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 14:03 +0100, Matthew Garrett wrote:
> Is there any chance of unifying the 32 and 64-bit code here as well?

I was under the impression that this wasn't possible for the cached case
because the 32-bit code path uses ioremap_cache() whereas 64-bit uses
init_memory_mapping() and __va().

Unless I'm missing something?

