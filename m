Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1ASUhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:37:54 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7936 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1ASUhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:37:52 -0500
Message-ID: <4D374B9A.3040002@caviumnetworks.com>
Date: Wed, 19 Jan 2011 12:37:46 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ryan Mallon <ryan@bluewatersys.com>
CC: Charles Manning <cdhmanning@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 01/10] Add yaffs2 file system: Allocation, block handling
 and bitmapping code
References: <1294974369-31647-1-git-send-email-cdhmanning@gmail.com> <1294974369-31647-2-git-send-email-cdhmanning@gmail.com> <4D3748C5.4070600@bluewatersys.com>
In-Reply-To: <4D3748C5.4070600@bluewatersys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2011 20:37:52.0272 (UTC) FILETIME=[BE5D9100:01CBB818]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 12:25 PM, Ryan Mallon wrote:
> On 01/14/2011 04:06 PM, Charles Manning wrote:
[...]
>> +	if (!allocator) {
>> +		YBUG();
>> +		return;
>> +	}
>
> You don't need this bug, the dereference of allocator below will oops
> with all the same information as bug.
>

Is that true for nommu systems too?

David Daney
