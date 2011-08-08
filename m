Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1HHJlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:41:42 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:47348 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1HHJlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:41:40 -0400
MIME-Version: 1.0
In-Reply-To: <4E3BE686.7070501@mit.edu>
References: <CAC4B8726E86A142B27A9E9A2F2F124701922F2855@rrsmsx505.amr.corp.intel.com>
	<4E3BE686.7070501@mit.edu>
Date: Mon, 8 Aug 2011 17:41:39 +0800
Message-ID: <CAM_iQpXRQ8C=y=DUt2pW_wQ_WKZU+2=ZBsGSPA2qmVATkTEQpA@mail.gmail.com>
Subject: Re: Is there a way to offload everything from cpu0 to other cpus?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: "Yung, Winson W" <winson.w.yung@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 8:48 PM, Andy Lutomirski <luto@mit.edu> wrote:
> On 08/04/2011 10:53 PM, Yung, Winson W wrote:
>>
>> Hi, I would like to know whether it is possible to offload everything
>> (kernel threads/user apps) to cpu1...x so that I can force cpu0 go into
>> idle?
>>
>> I can affinity all the interrupt to a different cpu by playing with the
>> /proc/irq/irqx/smp_affinity, how about everything else?
>>
>
> You probably want the isolcpus boot option.
>

I think Yung was looking for an interface to move tasks dynamically
after the system is boot.

Yung, why /sys/devices/system/cpu/cpuX/online doesn't work for you?
