Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2DXHCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:02:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36320 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2DXHCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:02:12 -0400
Date: Tue, 24 Apr 2012 03:00:50 -0400 (EDT)
Message-Id: <20120424.030050.767238391336824492.davem@davemloft.net>
To: sam@ravnborg.org
Cc: yinghai@kernel.org, tj@kernel.org, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Weirdness in __alloc_bootmem_node_high
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120424063236.GA23963@merkur.ravnborg.org>
References: <20120422200554.GA6385@merkur.ravnborg.org>
	<20120422.220054.1961736352806510855.davem@davemloft.net>
	<20120424063236.GA23963@merkur.ravnborg.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 Apr 2012 00:00:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 24 Apr 2012 08:32:36 +0200

> On Sun, Apr 22, 2012 at 10:00:54PM -0400, David Miller wrote:
>> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
>> index db4e821..3763302 100644
>> --- a/arch/sparc/Kconfig
>> +++ b/arch/sparc/Kconfig
>> @@ -109,6 +109,9 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
>>  config NEED_PER_CPU_PAGE_FIRST_CHUNK
>>  	def_bool y if SPARC64
>>  
>> +config NO_BOOTMEM
>> +	def_bool y if SPARC64
> 
> mm/Kconfig define NO_BOOTMEM so you can just add a "select NO_BOOTMEM"
> to SPARC64.

I was merely following the lead on x86 :-) but yes it should
probably be a select.

