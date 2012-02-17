Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2BQTcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:32:13 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:15194 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2BQTcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:32:12 -0500
Message-ID: <4F3EAAE3.5070705@chelsio.com>
Date: Fri, 17 Feb 2012 11:30:43 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: pull request: linux-firmware: update cxgb* firmwares
References: <4F35DB79.6070104@chelsio.com>  <20120211140701.GA5194@neilslaptop.think-freely.org>  <4F38A526.70900@chelsio.com> <4F3CADB7.1030802@chelsio.com> <1329450094.3258.34.camel@deadeye>
In-Reply-To: <1329450094.3258.34.camel@deadeye>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/2012 7:41 PM, Ben Hutchings wrote:
> On Wed, 2012-02-15 at 23:18 -0800, Divy Le Ray wrote:
> [...]
>> The following changes since commit 38118a598df73d5a9fd72bf04910e8298db82a46:
>>
>>     linux-firmware: brcm: add firmware for bcm43236 usb device
>> (2012-02-11 19:20:10 +0000)
>>
>> are available in the git repository at:
>>     git://git.chelsio.net/pub/git/linux-firmware for-upstream
>>
>> Divy Le Ray (3):
>>         linux-firmware: rename t4fw.bin
>>         linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
>>         linux-firmware: update cxgb3 driver firmware to revision 7.12.0
>>
>>    WHENCE                  |    4 +++-
>>    cxgb3/t3fw-7.12.0.bin   |  Bin 0 ->  31812 bytes
>>    cxgb4/t4fw-1.3.10.0.bin |  Bin 0 ->  241664 bytes
>>    cxgb4/t4fw-1.4.16.0.bin |  Bin 0 ->  298496 bytes
>>    cxgb4/t4fw.bin          |  Bin 241664 ->  17 bytes
>>    5 files changed, 3 insertions(+), 1 deletions(-)
>>    create mode 100755 cxgb3/t3fw-7.12.0.bin
>>    create mode 100644 cxgb4/t4fw-1.3.10.0.bin
>>    create mode 100644 cxgb4/t4fw-1.4.16.0.bin
>>    mode change 100644 =>  120000 cxgb4/t4fw.bin
> Are there any versions of the cxgb4 driver that will specifically
> request cxgb4/t4fw-1.3.10.0.bin?  If not, what's the point of keeping it
> around after changing the cxgb4/t4fw.bin symlink?

Hi Ben,

I originally removed cxgb4/t4fw-1.3.10.0.bin when I posted the request 
against David's tree.
Subsequent review from Neil requested to keep it around at least for a 
while (https://lkml.org/lkml/2012/2/11/61).
Either way is fine to me.

Cheers,
Divy

