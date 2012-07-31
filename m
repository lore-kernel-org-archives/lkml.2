Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2GaSWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab2GaSWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:22:44 -0400
Message-ID: <501818C0.1040605@redhat.com>
Date: Tue, 31 Jul 2012 13:41:20 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH 0/2][RFC] Better handling of insane CMOS values
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/31/2012 02:35 AM, John Stultz wrote:
> So CAI Qian noticed recent boot trouble on a machine that had its CMOS
> clock configured for the year 8200. 
> See: http://lkml.org/lkml/2012/7/29/188

In case anyone was wondering, the system's date was very much screwed up:

│ System Time .......................................... 13:39:40              │
│ System Date .......................................... Tue Jul 31, 8212

After testing these patches I set the year to 2012.

P.
