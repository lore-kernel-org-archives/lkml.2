Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1HJOdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:33:25 -0400
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:41725 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1HJOdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:33:24 -0400
Message-ID: <4E4296B0.5050302@ge.com>
Date: Wed, 10 Aug 2011 15:33:20 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] staging: vme: make [alloc|free]_consistent bridge
 specific
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch>	 <1312968830-13377-3-git-send-email-manohar.vanga@cern.ch>	 <1312981940.11924.68.camel@Joe-Laptop>  <4E4288CB.7080708@ge.com>	 <1312984261.11924.91.camel@Joe-Laptop>  <4E428DC3.5070302@ge.com> <1312986652.11924.94.camel@Joe-Laptop>
In-Reply-To: <1312986652.11924.94.camel@Joe-Laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2011 14:30:03.0775 (UTC) FILETIME=[FE5F68F0:01CC5769]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 15:30, Joe Perches wrote:
> On Wed, 2011-08-10 at 14:55 +0100, Martyn Welch wrote:
>> On 10/08/11 14:51, Joe Perches wrote:
>>> On Wed, 2011-08-10 at 14:34 +0100, Martyn Welch wrote:
>>>> On 10/08/11 14:12, Joe Perches wrote:
>>>>> Except for the name, those 2 blocks are identical.
>>>>> Maybe create a non-pci generic version instead?
>>>> I'm not sure you can (I spent quite a bit of time attempting to do just that
>>>> when I wrote the original).
>>> Doesn't something like this work?
> []
>> Could. Though we'd have to put this in a new common file for use by
>> vme_tsi148.c and vme_ca91cx42.c as the point of this was to get it out of the
>> VME core code. I'm just not sure that it's worth it.
> 
> That's a bit different than what you wrote earlier.
> No worries then.
> 

Sorry, I originally read your question to mean "create a function that didn't
use PCI specific functions".

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
