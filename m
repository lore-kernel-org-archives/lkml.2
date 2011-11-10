Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab1KJDJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:09:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:34429 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1KJDJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:09:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,486,1315206000"; 
   d="scan'208";a="35142207"
Subject: Re: [PATCH] PNP ACPI: Use real gsi
From: Zhang Rui <rui.zhang@intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <201111090935.52141.trenn@suse.de>
References: <1320372728-3235-1-git-send-email-trenn@suse.de>
	 <1320373233-3725-1-git-send-email-trenn@suse.de>
	 <201111090935.52141.trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 11:07:33 +0800
Message-ID: <1320894453.15460.15.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas,

can you attach the full dmesg output after applying the patch,
and the full acpidump of this machine please?

thanks,
rui

On Wed, 2011-11-09 at 16:35 +0800, Thomas Renninger wrote:
> Hi,
> 
> On Friday, November 04, 2011 03:20:33 AM Thomas Renninger wrote:
> > From: Yinghai Lu <yinghai@kernel.org>
> > 
> ...
> > On an IBM Xseries (x3850) this caused the machine to freeze around when
> > the init userspace process is tried to get started.
> > The reason is that the timer interrupt is not set up correctly on this
> > machine.
> ...
> 
> What is the state/opinion about this one?
> It fixes a sever bug/regression for me and it would be great to
> see this one in 3.2.
> 
> Thanks,
> 
>     Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


