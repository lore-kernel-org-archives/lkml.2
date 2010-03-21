Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0CULn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 07:43:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44678 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab0CULn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 07:43:57 -0400
To: Julia Lawall <julia@diku.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take desc
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
	<1267697339-5491-7-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.00.1003041142460.2014@localhost.localdomain>
	<4B900250.8020100@kernel.org>
	<Pine.LNX.4.64.1003050847170.21768@ask.diku.dk>
	<m1eije71et.fsf@fess.ebiederm.org>
	<Pine.LNX.4.64.1003211206380.7805@ask.diku.dk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 21 Mar 2010 04:43:46 -0700
In-Reply-To: <Pine.LNX.4.64.1003211206380.7805@ask.diku.dk> (Julia Lawall's message of "Sun\, 21 Mar 2010 12\:08\:28 +0100 \(CET\)")
Message-ID: <m1bpeh6gst.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: julia@diku.dk, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, yinghai@kernel.org, tglx@linutronix.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> writes:

> Another detail is that the type of irq is not always unsigned int.  
> Coccinelle will match unsigned int to just unsigned, but there are also 
> occurrences of uint32_t and u_int.  I don't know if it is desirable to 
> preserve these names, or if it would be just as well to put unsigned int 
> everywhere?

The correct type of irq is "unsigned int".  All others that are I know
of are a bit buggy.  Especially the cases that use int.

Eric
