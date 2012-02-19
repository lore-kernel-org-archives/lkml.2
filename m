Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2BSBg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 20:36:29 -0500
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:57836
	"EHLO l.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab2BSBg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 20:36:29 -0500
Message-ID: <4F4051E6.6030603@chelsio.com>
Date: Sat, 18 Feb 2012 17:35:34 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: pull request: linux-firmware: update cxgb* firmwares
References: <4F35DB79.6070104@chelsio.com>  <20120211140701.GA5194@neilslaptop.think-freely.org>  <4F38A526.70900@chelsio.com> <4F3CADB7.1030802@chelsio.com>  <1329450094.3258.34.camel@deadeye> <4F3EAAE3.5070705@chelsio.com>  <1329613104.3258.44.camel@deadeye> <1329613455.3258.45.camel@deadeye>
In-Reply-To: <1329613455.3258.45.camel@deadeye>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/2012 5:04 PM, Ben Hutchings wrote:
> On Sun, 2012-02-19 at 00:58 +0000, Ben Hutchings wrote:
>> On Fri, 2012-02-17 at 11:30 -0800, Divy Le Ray wrote:
>>> On 2/16/2012 7:41 PM, Ben Hutchings wrote:
> [...]
>>>> Are there any versions of the cxgb4 driver that will specifically
>>>> request cxgb4/t4fw-1.3.10.0.bin?  If not, what's the point of keeping it
>>>> around after changing the cxgb4/t4fw.bin symlink?
>>> Hi Ben,
>>>
>>> I originally removed cxgb4/t4fw-1.3.10.0.bin when I posted the request
>>> against David's tree.
>>> Subsequent review from Neil requested to keep it around at least for a
>>> while (https://lkml.org/lkml/2012/2/11/61).
>>> Either way is fine to me.
>> No, Neil said you need to maintain cxgb4/t4fw.bin, but it's perfectly
>> fine for that to be a symlink.
> So I've pulled your changes and then deleted the cxgb4/t4fw-1.3.10.0.bin
> as a separate commit.

Than you.

Cheers,
Divy

