Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1ATTqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:46:16 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:8555 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752956Ab1ATTqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:46:15 -0500
Message-ID: <4D389111.4000206@bluewatersys.com>
Date: Fri, 21 Jan 2011 08:46:25 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: Charles Manning <cdhmanning@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 01/10] Add yaffs2 file system: Allocation, block handling
 and bitmapping code
References: <1294974369-31647-1-git-send-email-cdhmanning@gmail.com> <1294974369-31647-2-git-send-email-cdhmanning@gmail.com> <4D3748C5.4070600@bluewatersys.com> <4D374B9A.3040002@caviumnetworks.com>
In-Reply-To: <4D374B9A.3040002@caviumnetworks.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 09:37 AM, David Daney wrote:
> On 01/19/2011 12:25 PM, Ryan Mallon wrote:
>> On 01/14/2011 04:06 PM, Charles Manning wrote:
> [...]
>>> +    if (!allocator) {
>>> +        YBUG();
>>> +        return;
>>> +    }
>>
>> You don't need this bug, the dereference of allocator below will oops
>> with all the same information as bug.
>>
> 
> Is that true for nommu systems too?

Actually, I'm not too sure. I understood that best practice was to avoid
putting BUG in places that will normally oops. Maybe someone can shed
some light on this?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
