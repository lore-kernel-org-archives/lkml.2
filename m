Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2HASYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 14:24:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35043 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab2HASYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:24:02 -0400
Message-ID: <50197460.8010906@gmail.com>
Date: Wed, 01 Aug 2012 20:24:32 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com> <1343757920-19713-2-git-send-email-levinsasha928@gmail.com> <20120731182330.GD21292@google.com> <50197348.9010101@gmail.com> <20120801182112.GC15477@google.com>
In-Reply-To: <20120801182112.GC15477@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 08:21 PM, Tejun Heo wrote:
> On Wed, Aug 01, 2012 at 08:19:52PM +0200, Sasha Levin wrote:
>> If we switch to using functions, we could no longer hide it anywhere
>> (we'd need to either turn the buckets into a struct, or have the
>> user pass it around to all functions).
> 
> Create an outer struct hash_table which remembers the size?

Possible. I just wanted to avoid creating new structs where they're not really required.

Do you think it's worth it for eliminating those two macros?

