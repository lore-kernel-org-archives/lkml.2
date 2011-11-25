Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1KYQiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 11:38:54 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:54126 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061Ab1KYQix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 11:38:53 -0500
Subject: Re: [PATCH] x86, efi: Convert efi_phys_get_time() args to physical
 addresses
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Zhang Rui <rui.zhang@intel.com>
In-Reply-To: <4EB82CA9.5080703@zytor.com>
References: <1318330333-4617-1-git-send-email-matt@console-pimps.org>
	 <1320665471.3572.110.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4EB82CA9.5080703@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 16:38:48 +0000
Message-ID: <1322239129.5216.0.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 11:08 -0800, H. Peter Anvin wrote:
> On 11/07/2011 03:31 AM, Matt Fleming wrote:
> > 
> > Ping?
> > 
> 
> Is this -stable material?

Are you picking this up, Peter?

-- 
Matt Fleming, Intel Open Source Technology Center

