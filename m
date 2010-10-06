Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab0JFUxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:53:35 -0400
Received: from mail.candelatech.com ([208.74.158.172]:45411 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab0JFUxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:53:34 -0400
Message-ID: <4CACE1B0.5000409@candelatech.com>
Date: Wed, 06 Oct 2010 13:53:04 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] slub:  Enable backtrace for create/delete points.
References: <1286395723-28271-1-git-send-email-greearb@candelatech.com> <alpine.DEB.2.00.1010061527560.6878@router.home>
In-Reply-To: <alpine.DEB.2.00.1010061527560.6878@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 01:32 PM, Christoph Lameter wrote:
> On Wed, 6 Oct 2010, greearb@candelatech.com wrote:
>
>> This patch attempts to grab a backtrace for the creation
>> and deletion points of the slub object.  When a fault is
>> detected, we can then get a better idea of where the item
>> was deleted.
>
> We have had patches like that for SLAB in the past. The backtrace was
> typically limited to 4 entries I believe.

Even 8 didn't show enough to be useful in my case, so I bumped it to 16,
but it would be easier to edit a #define than re-hack the entire
patch each time someone wanted such a thing...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

