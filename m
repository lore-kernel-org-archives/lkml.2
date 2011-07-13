Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1GMVVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:21:34 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57439 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GMVVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:21:33 -0400
Message-ID: <4E1E0C59.1030100@suse.cz>
Date: Wed, 13 Jul 2011 23:21:29 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.43
References: <20110713034559.GA16150@kroah.com> <4E1E0B40.1030905@suse.cz>
In-Reply-To: <4E1E0B40.1030905@suse.cz>
X-Enigmail-Version: 1.2pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 11:16 PM, Jiri Slaby wrote:
> On 07/13/2011 05:45 AM, Greg KH wrote:
>> Joe Perches (2):
>>       bug.h: Add WARN_RATELIMIT
>>       net: filter: Use WARN_RATELIMIT
> 
> Hi, this causes a build failure on PPC with minimalistic config (PS3) [1]:
> net/core/filter.c: In function 'sk_run_filter':
> net/core/filter.c:297: error: implicit declaration of function
> 'WARN_RATELIMIT'
> 
> net/core/filter.c should include linux/bug.h (or linux/kernel.h).

Ah, no, PS3 doesn't have CONFIG_BUG set.

> [1]
> http://gitorious.org/opensuse/kernel-source/blobs/SLE11-SP1/config/ppc/ps3
> 
> regards,
-- 
js
suse labs
