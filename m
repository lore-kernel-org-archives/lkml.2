Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1BVTcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:32:41 -0500
Received: from mail03do.versatel.de ([89.245.129.23]:33259 "EHLO
	mail03do.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1BVTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:32:40 -0500
Message-ID: <4D640F67.3040109@versanet.de>
Date: Tue, 22 Feb 2011 20:32:55 +0100
From: "pantherchen@versanet.de" <pantherchen@versanet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110208 Thunderbird/3.1.8
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
References: <4D62CE9C.7090806@versanet.de> <20110222081752.GP31267@htj.dyndns.org> <20110222085223.GC11681@core.coreip.homeip.net> <20110222090255.GR31267@htj.dyndns.org> <B04A0050-5AE7-4072-BE6F-279E24B0DA64@gmail.com> <4D63D062.3040404@versanet.de> <20110222172254.GA13114@core.coreip.homeip.net> <20110222175955.GA27991@core.coreip.homeip.net>
In-Reply-To: <20110222175955.GA27991@core.coreip.homeip.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 06:59 PM, Dmitry Torokhov wrote:
> On Tue, Feb 22, 2011 at 09:22:54AM -0800, Dmitry Torokhov wrote:
>> Just to confirm, if you revert commit
>>
>> 	8ee294cd9def0004887da7f44b80563493b0a097
>>
>> from 2.6.38-rc6, does this restore boot time?

Yes, it's booting fine with that commit reverted.

> And if that indeed fixes the issue I wonder if the reason for the stall
> is that we trip on flush_scheduled_work() somewhere. If you could stick
> dump_stack() into flush_scheduled_work() that might give us some clues.

I wasn't sure where to put the dump_stack() call, so I placed one before 
and one after the flush_workqueue() call.

Here's the part that turned up in dmesg: http://paste.ubuntu.com/570729/

Regards,

Hernando Torque
