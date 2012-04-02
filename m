Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2DBP7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:59:19 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:60175 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2DBP7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:59:17 -0400
Message-ID: <4F79CCD4.4040606@tilera.com>
Date: Mon, 2 Apr 2012 11:59:16 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [PATCH 10/11] tile: fix multiple build failures from system.h
 dismantle
References: <1333312727-11428-11-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com> <30198.1333345969@redhat.com>
In-Reply-To: <30198.1333345969@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2012 1:52 AM, David Howells wrote:
> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>
>> Commit bd119c69239322caafdb64517a806037d0d0c70a
>>
>>     "Disintegrate asm/system.h for Tile"
>>
>> created the asm/switch_to.h file, but did not add an include
>> of it to all its users.
>>
>> Also, commit b4816afa3986704d1404fc48e931da5135820472
>>
>>         "Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h"
>>
>> introduced the concept of asm/cmpxchg.h but the tile arch
>> never got one.  Fork the cmpxchg content out of the asm/atomic.h
>> file to create one.
>>
>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> Acked-by: David Howells <dhowells@redhat.com>

Thanks!  I can push this through the tile tree along with some other
bug-fix changes for -rc2.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

