Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2I1INT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:13:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56846 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab2I1IKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:10:10 -0400
Message-ID: <50655B56.5080008@ahsoftware.de>
Date: Fri, 28 Sep 2012 10:09:58 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
References: <50531629.9020107@ahsoftware.de> <20120925110206.GD28937@mwanda> <50643C4A.9010202@ahsoftware.de> <20120927151232.GA12210@quack.suse.cz> <506474E8.3030300@ahsoftware.de> <50647CCC.7010407@ahsoftware.de> <5064945C.4020403@ahsoftware.de> <20120927200538.GC12553@quack.suse.cz>
In-Reply-To: <20120927200538.GC12553@quack.suse.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2012 22:05, schrieb Jan Kara:
> On Thu 27-09-12 20:01:00, Alexander Holler wrote:
>> [  111.087356] EXT4-fs (sdc1): mounted filesystem with ordered data
>> mode. Opts: (null)
>> [  672.868948] CPU4: Core temperature above threshold, cpu clock
>> throttled (total events = 1)
>> [  672.868949] CPU0: Core temperature above threshold, cpu clock
>> throttled (total events = 1)
>> [  672.869970] CPU0: Core temperature/speed normal
>> [  672.869971] CPU4: Core temperature/speed normal
>> [  688.285419] CPU6: Core temperature above threshold, cpu clock
>> throttled (total events = 1)
>> [  688.285421] CPU2: Core temperature above threshold, cpu clock
>> throttled (total events = 1)
>> [  688.286442] CPU2: Core temperature/speed normal
>> [  688.286443] CPU6: Core temperature/speed normal
>> [  698.822614] CPU3: Core temperature above threshold, cpu clock
>> throttled (total events = 1)
>> [  698.822615] CPU7: Core temperature above threshold, cpu clock
>> throttled (total events = 1)
>> [  698.824674] CPU3: Core temperature/speed normal
>> [  698.824675] CPU7: Core temperature/speed normal
>> [  706.979633] CPU1: Core temperature above threshold, cpu clock
>> throttled (total events = 1)
>> [  706.979635] CPU5: Core temperature above threshold, cpu clock
>> throttled (total events = 1)
>> [  706.980648] CPU1: Core temperature/speed normal
>> [  706.980649] CPU5: Core temperature/speed normal
>> [  899.540485] [Hardware Error]: Machine check events logged
>    This last message usually means hardware really has an issue. You can
> use mcelog tool to find out what problems did the hardware report.

They are already in the messages(.txt) I've attached earlier and are all 
like those two below:
----------
MCE 30
Sun Sep 25 15:10:56 2011
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 6 THERMAL EVENT TSC 28e5906c38e0
Processor 6 heated above trip temperature. Throttling enabled.
Please check your system cooling. Performance will be impacted
STATUS 880003c3 MCGSTATUS 0
CPUID Vendor Intel Family 6 Model 30
MCE 31
Sun Sep 25 15:10:56 2011
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 6 THERMAL EVENT TSC 28e5906c8b66
Processor 6 below trip temperature. Throttling disabled
STATUS 88050282 MCGSTATUS 0
CPUID Vendor Intel Family 6 Model 30
----------

Regards,

Alexander

