Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab0LNJPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:15:51 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:39688 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab0LNJPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:15:49 -0500
Message-ID: <4D0735C1.5090100@ge.com>
Date: Tue, 14 Dec 2010 09:15:45 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Staging: vme_bridge: mark vme_master_resource->kern_base
 as __iomem
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>	 <1292246196-2332-2-git-send-email-namhyung@gmail.com>	 <20101213183601.GB11745@kroah.com> <1292302327.1696.31.camel@leonhard>
In-Reply-To: <1292302327.1696.31.camel@leonhard>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Dec 2010 09:15:47.0296 (UTC) FILETIME=[7E4ECE00:01CB9B6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/10 04:52, Namhyung Kim wrote:
> 2010-12-13 (월), 10:36 -0800, Greg KH:
>> On Mon, Dec 13, 2010 at 10:16:30PM +0900, Namhyung Kim wrote:
>>> vme_master_resource->kern_base is mapped by ioremap_nocache()
>>> thus should be marked as __iomem.
>>>
>>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>>
>> I need some acks from Martyn on this series (minus the broken 1/8 patch)
>> before I can apply them.  Martyn?
>>
>> thanks,
>>
>> greg k-h
> 
> Now I've checked -next tree and found patch 2 (partially), 3, 5, 6 and 8
> are already in the tree. Sorry for my carelessness :( Will send v2.
> 
> 

I had a quick peek at these patches when they can in yesterday, I
thought there may have been quite a bit of overlap with the patches that
Emilio posted and needed to find time to look in more detail.

Martyn

-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
