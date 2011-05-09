Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1EIX3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:29:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56663 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab1EIX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:29:37 -0400
Subject: Re: [PATCH 0/4] Consolidate i8253 clocksource
From: John Stultz <john.stultz@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <20110509132738.GB16919@n2100.arm.linux.org.uk>
References: <20110509132738.GB16919@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 16:29:22 -0700
Message-ID: <1304983762.2939.39.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 14:27 +0100, Russell King - ARM Linux wrote:
> Three architectures have an i8253 PIT clocksource, and each duplicates
> the code for this.  The initial patch extracts a common implementation
> to drivers/clocksource, and subsequent patches convert each architecture
> to use this copy.

Very cool! The series looks good to me. 

Although maybe should we get rid of the inb_p redefinitions in a later
cleanup? 

Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john


