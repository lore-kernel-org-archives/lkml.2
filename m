Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab2EUX65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:58:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36547 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab2EUX6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:58:55 -0400
Message-ID: <4FBAD6B1.1030304@linaro.org>
Date: Mon, 21 May 2012 16:58:41 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 2/6] ntp: remove useless parameter
References: <cover.1337348892.git.richardcochran@gmail.com> <25d1b7ebb22bc559132a66209c990168f5de49ce.1337348892.git.richardcochran@gmail.com>
In-Reply-To: <25d1b7ebb22bc559132a66209c990168f5de49ce.1337348892.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052123-9360-0000-0000-0000068C1862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 07:09 AM, Richard Cochran wrote:
> This patch removes some leftover cruft in the NTP code.
>
> Signed-off-by: Richard Cochran<richardcochran@gmail.com>

FYI: This one didn't apply when I tried to add it to the other cleanups 
you've sent me along with tip/timers/core.
Please rework it against the tree I sent Thomas and I'll queue it up.

thanks
-john

