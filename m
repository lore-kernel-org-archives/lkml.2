Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2GXMJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 08:09:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab2GXMJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 08:09:07 -0400
Message-ID: <500E904F.8010004@redhat.com>
Date: Tue, 24 Jul 2012 08:08:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] time: Fix casting issue in tk_set_xtime and tk_xtime_add
References: <1343074957-16541-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1343074957-16541-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/23/2012 04:22 PM, John Stultz wrote:
> Fix missing casts that can cause boot problems on 32bit systems,
> most easily observed with Xen systems. This issue was introduced
> w/ 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Acked-by: Prarit Bhargava <prarit@redhat.com>

P.
