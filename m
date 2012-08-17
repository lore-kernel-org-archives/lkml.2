Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2HQFsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:48:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63403 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab2HQFsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:48:01 -0400
Message-ID: <502DDB0E.8070001@vflare.org>
Date: Thu, 16 Aug 2012 22:47:58 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 0/7] zram/zsmalloc promotion
References: <1344406340-14128-1-git-send-email-minchan@kernel.org> <20120814023530.GA9787@kroah.com> <20120814062246.GB31621@bbox>
In-Reply-To: <20120814062246.GB31621@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 11:22 PM, Minchan Kim wrote:
> Hi Greg,
> 
> On Mon, Aug 13, 2012 at 07:35:30PM -0700, Greg Kroah-Hartman wrote:
>> On Wed, Aug 08, 2012 at 03:12:13PM +0900, Minchan Kim wrote:
>>> This patchset promotes zram/zsmalloc from staging.
>>> Both are very clean and zram is used by many embedded product
>>> for a long time.
>>>
>>> [1-3] are patches not merged into linux-next yet but needed
>>> it as base for [4-5] which promotes zsmalloc.
>>> Greg, if you merged [1-3] already, skip them.
>>
>> I've applied 1-3 and now 4, but that's it, I can't apply the rest
> 
> Thanks!
> 
>> without getting acks from the -mm maintainers, sorry.  Please work with
> 
> Nitin suggested zsmalloc could be in /lib or /zram out of /mm but I want
> to confirm it from akpm so let's wait his opinion.
> 

akpm, please?

> Anyway, another question. zram would be under driver/blocks.
> Do I need ACK from Jens for that?
> 

Added Jens to CC list.

Thanks,
Nitin

