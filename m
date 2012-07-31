Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2GaRpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:45:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64459 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2GaRpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:45:47 -0400
Date: Tue, 31 Jul 2012 19:45:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/5] time/jiffies changes for tip/timers/core
Message-ID: <20120731174541.GB21582@gmail.com>
References: <1343414893-45779-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343414893-45779-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> Hey Thomas, Ingo,
> 	Here's updated time/jiffies patches including Ingo's
> feedback for tip/timers/core.
> 
> Let me know if there's any further tweaks you'd like to see.

The code looks very nice now. I've applied them to -tip and 
pushed them out.

Thanks,

	Ingo
