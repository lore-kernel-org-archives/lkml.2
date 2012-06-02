Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550Ab2FBS5G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 14:57:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34680 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965414Ab2FBS5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 14:57:04 -0400
Date: Sat, 2 Jun 2012 21:56:57 +0300
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH RESEND] x86: Avoid contention on cpa_lock if possible
Message-ID: <20120602185657.GB15595@WorkStation.localnet>
References: <1333716049-26122-1-git-send-email-ido@wizery.com>
 <1334873492-31255-1-git-send-email-ido@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334873492-31255-1-git-send-email-ido@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 01:11:32AM +0300, Ido Yariv wrote:
> From: Shai Fultheim <shai@scalemp.com>
> 
> Some architectures (e.g. vSMP) do not require to serialize cpa, for
> instance, by guaranteeing that the most recent TLB entry will always be
> used.
> 
> To avoid needless contention on cpa_lock, do not lock/unlock it on such
> architectures.
> 
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: added should_serialize_cpa, handled potential race, and
>                  reworded the commit message]
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Ping?

Thanks,
Ido.
