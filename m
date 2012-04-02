Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2DBSFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:05:40 -0400
Received: from mail1.windriver.com ([147.11.146.13]:35613 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2DBSFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:05:39 -0400
Message-ID: <4F79EA64.3000100@windriver.com>
Date: Mon, 2 Apr 2012 14:05:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: David Howells <dhowells@redhat.com>, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: [PATCH 10/11] tile: fix multiple build failures from system.h
 dismantle
References: <1333312727-11428-11-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com> <30198.1333345969@redhat.com> <4F79CCD4.4040606@tilera.com>
In-Reply-To: <4F79CCD4.4040606@tilera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-02 11:59 AM, Chris Metcalf wrote:
> On 4/2/2012 1:52 AM, David Howells wrote:
>> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>>
>>> Commit bd119c69239322caafdb64517a806037d0d0c70a
>>>
>>>     "Disintegrate asm/system.h for Tile"
>>>
>>> created the asm/switch_to.h file, but did not add an include
>>> of it to all its users.
>>>
>>> Also, commit b4816afa3986704d1404fc48e931da5135820472
>>>
>>>         "Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h"
>>>
>>> introduced the concept of asm/cmpxchg.h but the tile arch
>>> never got one.  Fork the cmpxchg content out of the asm/atomic.h
>>> file to create one.
>>>
>>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Acked-by: David Howells <dhowells@redhat.com>
> 
> Thanks!  I can push this through the tile tree along with some other
> bug-fix changes for -rc2.

Perfect.  I see you have a tree in linux-next, so I'll drop it
from my series here without having to worry about reintroducing
the build failure.

Thanks.
Paul.

> 
