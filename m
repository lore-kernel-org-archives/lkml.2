Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1JIC5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 22:57:12 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:44493 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1JIC5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 22:57:11 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
Date: Sun, 09 Oct 2011 13:57:00 +1100
From: "Bojan Smojver" <bojan@rexursive.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
X-Mailer: LCG ProfiMail 3.48
Message-ID: <9904162235.1002635820@rexursive.com>
References: <1317342456.1959.6.camel@shrek.rexursive.com> <3169978091.1002283638@rexursive.com> <201110062037.14322.rjw@sisk.pl> <201110062045.48689.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------- Original message -------
> From: Rafael J. Wysocki <rjw@sisk.pl>
> To: bojan@rexursive.com
> Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
> Sent: 7.10.'11,  4:48
>
> On Thursday, October 06, 2011, Rafael J. Wysocki wrote:
>> On Wednesday, October 05, 2011, Bojan Smojver wrote:
>> > ------- Original message -------
>> > > From: Rafael J. Wysocki
>> > > Sent: 5.10.'11,  8:10
>> >
>> > > Applied to linux-pm/linux-next.
>> >
>> > Thank you.
>>
>> I get a kernel panic on a test box using a x86_64 kernel with this patch
>> applied.
>
> The panic happens during late resume, when trying to switch to the 
> hibernated
> kernel.

Yeah, something is not quite right. My CRC32 checks keep failing on resume. 
I don't get a panic, but still, this should not happen. Looking...

--
Bojan 
