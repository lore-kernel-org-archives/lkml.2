Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab1CPSc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:32:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:2230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1CPSct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:32:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,195,1299484800"; 
   d="scan'208";a="720880685"
From: Andi Kleen <andi@firstfloor.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: MCE hardware error, but no message
References: <alpine.LNX.2.01.1103122136220.20070@obet.zrqbmnf.qr>
Date: Wed, 16 Mar 2011 11:31:38 -0700
In-Reply-To: <alpine.LNX.2.01.1103122136220.20070@obet.zrqbmnf.qr> (Jan
	Engelhardt's message of "Sat, 12 Mar 2011 21:49:19 +0100 (CET)")
Message-ID: <m2tyf2lxx1.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@medozas.de> writes:

> Running Linux 2.6.37, I am getting these errors on one of a box:
>
> [696782.810387] [Hardware Error]: No human readable MCE decoding support 
> on this CPU type.
> [696782.810470] [Hardware Error]: Run the message through 'mcelog 
> --ascii' to decode.
> [696783.585853] [Hardware Error]: No human readable MCE decoding support 
> on this CPU type.
> [696783.585937] [Hardware Error]: Run the message through 'mcelog 
> --ascii' to decode.
>
> Except that it never tells me the actual non-human readable form.

mcelog logs them. The kernel shouldn't be spewing these messages
at all, especially not for corrected errors (this is a still 
unfixed regression for Intel CPUs)

Here's an older fix:

http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=commit;h=6e3c7411d2b86bff210c59caa432e8e862037bfd

> How would I get the messages to run through mcelog?

They are already logged, no need to do anything further.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
