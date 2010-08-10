Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab0HJEz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 00:55:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57042 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab0HJEzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 00:55:25 -0400
Message-ID: <4C60DBD5.8090801@vflare.org>
Date: Tue, 10 Aug 2010 10:25:49 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] Reduce per table entry overhead by 4 bytes
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>	<1281374816-904-6-git-send-email-ngupta@vflare.org> <AANLkTikERp9DOpK=1R_UdjuNrS6dbAkX+Q5kysgVcv0k@mail.gmail.com>
In-Reply-To: <AANLkTikERp9DOpK=1R_UdjuNrS6dbAkX+Q5kysgVcv0k@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 12:29 AM, Pekka Enberg wrote:
> On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> Each zram device maintains an array (table) that maps
>> index within the device to the location of corresponding
>> compressed chunk. Currently we store 'struct page' pointer,
>> offset with page and various flags separately which takes
>> 12 bytes per table entry. Now all these are encoded in a
>> single 'phys_add_t' value which results in savings of 4 bytes
>> per entry (except on PAE systems).
>>
>> Unfortunately, cleanups related to some variable renames
>> were mixed in this patch. So, please bear some additional
>> noise.
> 
> The noise makes this patch pretty difficult to review properly. Care
> to spilt the patch into two pieces?
> 

Ok, I will split them as separate patches.

Thanks for all the reviews and Acks.
Nitin

