Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2KMP4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:56:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:49047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2KMP4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:56:09 -0500
Message-ID: <50A26D66.4060603@infradead.org>
Date: Tue, 13 Nov 2012 07:55:18 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] wireless: brcmfmac: fix printk format warning
References: <20121101163622.129b59967d2ee76e6946874a@canb.auug.org.au>	 <5092B4BE.4080803@infradead.org> <5092B900.2090801@broadcom.com>	 (sfid-20121101_190234_358746_9918835B) <1351798279.17469.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1351798279.17469.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 12:31 PM, Johannes Berg wrote:

> On Thu, 2012-11-01 at 19:01 +0100, Arend van Spriel wrote:
>> On 11/01/2012 06:43 PM, Randy Dunlap wrote:
>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>
>>> Fix printk format warning for ssid_len, which is a size_t:
>>>
>>> drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3941:2: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
>>>
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> Cc:	brcm80211-dev-list@broadcom.com
>>
>>
>> We actually have a patch ready for that with credit to people who
>> reported it. We can add you to that list ;-)
> 
> Which you've been sitting on for WAY too long already :)

ping Arend.
Please have your patch included in linux-next builds.  thanks.

-- 
~Randy
