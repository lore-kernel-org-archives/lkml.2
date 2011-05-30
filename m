Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1E3FnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:43:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49703 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab1E3FnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:43:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE32E46.5040004@jp.fujitsu.com>
Date: Mon, 30 May 2011 14:42:30 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/12] x86, mce: introduce mce_gather_info()
References: <4DDF21DE.9040705@jp.fujitsu.com>	<4DDF23F5.1090206@jp.fujitsu.com>	<BANLkTinCRX3YOXwuphRTBS=OcHuC07a1jw@mail.gmail.com>	<20110527080051.GB19300@elte.hu> <BANLkTimtcXNjzeRM+cX22fUEFZ5stk8Z3g@mail.gmail.com>
In-Reply-To: <BANLkTimtcXNjzeRM+cX22fUEFZ5stk8Z3g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/28 1:29), Tony Luck wrote:
> On Fri, May 27, 2011 at 1:00 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> At minimum an explanation should be put into the code. Small, hidden
>> dependencies might be common job security moves in the closed source
>> world but this is open source ;-)
> 
> Seto-san,
> 
> Perhaps this more descriptive comment for you new mce_gather_info()
> function would help:
> 
> /*
>  * Collect all global (w.r.t. this processor) status about this machine
>  * check into our "mce" struct so that we can use it later to assess
>  * the severity of the problem as we read per-bank specific details.
>  */

Thank you very much!
I'll update my patch to have this comment.

Thanks,
H.Seto

