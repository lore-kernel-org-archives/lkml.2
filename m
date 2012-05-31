Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab2EaPlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:41:20 -0400
Received: from mga10.intel.com ([192.55.52.92]:8632 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932451Ab2EaPlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:41:19 -0400
Subject: Re: [RFC][PATCH 1/1] x86, efi: EFI boot stub config file support
From: Matt Fleming <matt.fleming@intel.com>
To: Shea Levy <shea@shealevy.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Maarten Lankhorst <m.b.lankhorst@gmail.com>
In-Reply-To: <4F690314.3080601@shealevy.com>
References: <4F660313.1080301@shealevy.com> <4F660402.4040300@shealevy.com>
	 <4F690314.3080601@shealevy.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 31 May 2012 16:41:09 +0100
Message-ID: <1338478869.13028.64.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 18:22 -0400, Shea Levy wrote:
> On 03/18/2012 11:49 AM, Shea Levy wrote:
> > On 3/18/12 11:45 AM, Shea Levy wrote:
> >> Hello,
> >>
> >> Inlined is a patch to have the kernel read its parameters from a
> >> config file when booted via the EFI boot stub without any parameters
> >> passed. This patch roughly follows the plan I discussed when
> >> proposing this idea, except now the file is found relative to the
> >> location of the bzImage and there is no additional check to see if
> >> image->parent_handle is NULL (despite the spec saying it will be NULL
> >> when the image was loaded by the firmware itself, it was never NULL
> >> on any of the systems I tested).
> >>
> >> Cheers,
> >> Shea Levy
> 
> I haven't yet gotten a reply to this, should I wait until after the 
> merge window and resubmit it then?

I'm wondering what use case you're catering for here that can't be
handled with efibootmgr? What problem does this patch fix?

