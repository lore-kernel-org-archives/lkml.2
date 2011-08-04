Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1HDQA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:00:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44093 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1HDQA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:00:57 -0400
Message-ID: <4E3AC235.1060104@lwfinger.net>
Date: Thu, 04 Aug 2011 11:00:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 3.0-git - bisected to commit dd4e5d3ac4a76b868daf30e35bd572def96c30ed
References: <4E3AB5E0.5080506@lwfinger.net> <1312471150.16729.37.camel@twins>
In-Reply-To: <1312471150.16729.37.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 10:19 AM, Peter Zijlstra wrote:
> On Thu, 2011-08-04 at 10:08 -0500, Larry Finger wrote:
>> The logs for a recent git pull from Linus's tree show the warning below. The
>> problem has been bisected to commit dd4e5d3ac4a7 with the commit message of
>>
>> ===============
>> lockdep: Fix trace_[soft,hard]irqs_[on,off]() recursion
>
> Thanks, but yes that's known, and a patch has been queued for merger
> that should solve this:
>
> https://lkml.org/lkml/2011/8/4/60

Sorry for the noise. I expected that this was a known problem and searched for 
it. I probably used the wrong number of digits in the hash.

Your patch does fix the issue for me.

Thanks,

Larry
