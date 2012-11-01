Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853Ab2KAUvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:51:21 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2391 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab2KAUvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:51:19 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5092E0B7.9040608@broadcom.com>
Date: Thu, 1 Nov 2012 21:51:03 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028
 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Randy Dunlap" <rdunlap@infradead.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] wireless: brcmfmac: fix printk format warning
References: <20121101163622.129b59967d2ee76e6946874a@canb.auug.org.au>
 <5092B4BE.4080803@infradead.org> <5092B900.2090801@broadcom.com> (
 sfid-20121101_190234_358746_9918835B)
 <1351798279.17469.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1351798279.17469.0.camel@jlt4.sipsolutions.net>
X-Enigmail-Version: 1.4.5
X-WSS-ID: 7C8C3FD83QC3490105-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 08:31 PM, Johannes Berg wrote:
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
> 
> johannes
> 
> 

True. I was actually going to make Hante fix it, but failed my
management skills miserably. Fixed it myself in the end. There are quite
a number of patches queued up. Another flush() not working :-)

Gr. AvS

