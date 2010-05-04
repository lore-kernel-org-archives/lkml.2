Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434Ab0EDW1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:27:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41484 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464Ab0EDW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CIEVoTXCbKpwyxsm5eAkFqVvTH8EbY9yY/jXnpxROGWB7P89zu2rmZeAmrDaM3qF4Y
         kTu/fad5tG7KeEfRTnR0ReWIxJ+VLmjolcqFMC/eOS4XFwIAYuFOtqT4Tq+7OME/hPFu
         qhjy5O+VBtm1XVzOgQ4nBTSm+KYzNQfeYHhyc=
Message-ID: <4BE09F42.9070909@lwfinger.net>
Date: Tue, 04 May 2010 17:27:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.11 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to write marker info in MMIO trace from kernel
References: <4BE06933.9080202@lwfinger.net> <1272998579.9739.235.camel@gandalf.stny.rr.com>
In-Reply-To: <1272998579.9739.235.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 01:42 PM, Steven Rostedt wrote:
> On Tue, 2010-05-04 at 13:36 -0500, Larry Finger wrote:
>> Stephen,
>>
>> I hope you are the correct person for this question.
>>
>> I would like to write information into the MMIO trace file similar to
>> what the user space write to /sys/.../trace_marker would accomplish,
>> however, I want to do it in place of printk statements in the driver I'm
>> tracing. Do you have any suggestions on how to do this? I have tools to
>> merge the trace dump with dmesg output, but the latter lags behind and I
>> do not get good correlation.
> 
> You can use "trace_printk()". I think that is what you are looking for.

Thanks for the info. One other question - when I write only mmiotrace to
the current_tracer, the trace_printk() stuff does not end up in the
buffer. I can get it by using the "sysprof" tracer, but that has a lot
of stuff I do not want. Did I miss some configuration? My list of
available tracers is "blk kmemtrace mmiotrace wakeup_rt wakeup function
sysprof sched_switch nop".

Thanks,

Larry
