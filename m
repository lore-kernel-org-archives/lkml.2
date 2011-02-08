Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab1BHEuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 23:50:11 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:46767 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1BHEuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 23:50:09 -0500
Message-ID: <4D50CB50.6060506@snapgear.com>
Date: Tue, 8 Feb 2011 14:49:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [patch 01/10] m68knommu: 5772: Replace private irq flow handler
References: <20110206233845.480884215@linutronix.de> <20110206233904.203393608@linutronix.de>
In-Reply-To: <20110206233904.203393608@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2011 04:50:07.0246 (UTC) FILETIME=[A86E32E0:01CBC74B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 07/02/11 09:39, Thomas Gleixner wrote:
> That's a conversion to the new irq_chips and a cleanup to irq_desc
> accessor functions. Finally it sets GENERIC_HARDIRQS_NO_DEPRECATED.
>
> Warning: untested.

I am fine with all of these, so:

Acked-by: Greg Ungerer <gerg@uclinux.org>

I compile tested to cover all changes, only fix was to patch 7
(as noted in reply to that patch). I can't run test to cover
all changes right at the moment, but on the one board I can try
it ran with no problems.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
