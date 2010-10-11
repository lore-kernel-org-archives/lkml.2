Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750791Ab0JKELZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 00:11:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51145 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0JKEK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 00:10:59 -0400
Message-ID: <4CB28DD6.8000505@oracle.com>
Date: Sun, 10 Oct 2010 21:08:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>
Subject: Re: linux-next: Tree for October 8 (staging/brcm80211)
References: <20101008161552.07c9f137.sfr@canb.auug.org.au> <20101010115832.0bf5dff8.randy.dunlap@oracle.com> <20101010202906.GA4900@kroah.com>
In-Reply-To: <20101010202906.GA4900@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/10 13:29, Greg KH wrote:
> On Sun, Oct 10, 2010 at 11:58:32AM -0700, Randy Dunlap wrote:
>> On Fri, 8 Oct 2010 16:15:52 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20101007:
>>
>>
>>
>> drivers/staging/brcm80211/brcmfmac/dhd_linux.c:432: note: expected 'void *' but argument is of type 'sk_buff_data_t'
>> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:1337: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> 
> This is x86-64, right?

Yes.

>> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:2120: warning: initialization from incompatible pointer type
>> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:2121: warning: initialization from incompatible pointer type
>> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:2122: warning: initialization from incompatible pointer type
>> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:4035: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
>> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:4048: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> 
> I'll work on these.
> 
> thanks,
> 
> greg k-h


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
