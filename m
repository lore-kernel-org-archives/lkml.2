Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab2BPJS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:18:29 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:46360 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab2BPJS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:18:26 -0500
Message-ID: <4F3CC9DD.6070101@bootc.net>
Date: Thu, 16 Feb 2012 09:18:21 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 02/11] firewire: Move fw_card kref functions into linux/firewire.h
References: <1328989452-20921-1-git-send-email-bootc@bootc.net> <1329317248-94128-1-git-send-email-bootc@bootc.net> <1329317248-94128-3-git-send-email-bootc@bootc.net> <20120215201004.0f8f4300@stein>
In-Reply-To: <20120215201004.0f8f4300@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/2012 19:10, Stefan Richter wrote:
> On Feb 15 Chris Boot wrote:
>> When writing a firewire driver that doesn't deal with struct fw_device
>> objects (e.g. it only publishes FireWire units and doesn't subscribe to
>> them), you likely need to keep referenced to struct fw_card objects so
>> that you can send messages to other nodes. This patch moves
>> fw_card_put(), fw_card_get() and fw_card_release() into the public
>> include/linux/firewire.h header instead of drivers/firewire/core.h, and
>> adds EXPORT_SYMBOL_GPL(fw_card_release).
>>
>> The firewire-sbp-target module requires these so it can keep a reference
>> to the fw_card object in order that it can fetch ORBs to execute and
>> read/write related data and status information.
>>
>> Signed-off-by: Chris Boot<bootc@bootc.net>
>> Cc: Clemens Ladisch<clemens@ladisch.de>
>
> Acked-by: Stefan Richter<stefanr@s5r6.in-berlin.de>

Thanks!

[snip]

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net
