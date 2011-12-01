Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab1LAX6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:58:33 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33071 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab1LAX6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:58:32 -0500
Message-ID: <1322783907.21423.153.camel@work-vm>
Subject: Re: [PATCH 1/3] clocksource: Also tweak ->maxadj in
 clocksource_calc_mult_shift()
From: john stultz <johnstul@us.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 01 Dec 2011 15:58:27 -0800
In-Reply-To: <1322724016-9770-2-git-send-email-yong.zhang0@gmail.com>
References: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
	 <1322724016-9770-2-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11120123-4242-0000-0000-00000041037A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 15:20 +0800, Yong Zhang wrote:
> There is still user of clocksource_calc_mult_shift(), and it's
> complement to commit d65670a7 [clocksource: Avoid selecting mult
> values that might overflow when adjusted]

I'd probably drop this patch, as its just extra churn.

Again, I've queued 2/3 to resolve the issue and queued a simplified 3/3
to just remove clocksource_calc_mult_shift. 

thanks
-john




