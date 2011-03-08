Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1CHILB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 03:11:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37485 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1CHIK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 03:10:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vH+gwv/hSx2QSk6d3hegSeVGpypq/mBWWzlC7imaH/5gmFk5YKXGZs/OhcDx9wFqmC
         JsisKUF61sdMXI2JzNDtdQRVOU40yBlXUQOWjJZ7lY1Rocf+D1RIeJMSvcU8cmrC6bL0
         7ALjHPun6CRVnTqAk9S4XbqhrI0AhUOKzMz68=
Message-ID: <4D75E4E6.9020507@gmail.com>
Date: Tue, 08 Mar 2011 11:12:22 +0300
From: Andrew Vagin <avagin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Andrey Vagin <avagin@openvz.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable()
References: <1299325456-2687-1-git-send-email-avagin@openvz.org>	<20110305152056.GA1918@barrios-desktop>	<4D72580D.4000208@gmail.com>	<20110305155316.GB1918@barrios-desktop>	<4D7267B6.6020406@gmail.com>	<20110305170759.GC1918@barrios-desktop>	<20110307135831.9e0d7eaa.akpm@linux-foundation.org> <20110308094438.1ba05ed2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110308094438.1ba05ed2.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All
> I agree with Minchan and can't think this is a real fix....
> Andrey, I'm now trying your fix and it seems your fix for oom-killer,
> 'skip-zombie-process' works enough good for my environ.
>
> What is your enviroment ? number of cpus ? architecture ? size of memory ?
Processort: AMD Phenom(tm) II X6 1055T Processor (six-core)
Ram: 8Gb
RHEL6, x86_64. This host doesn't have swap.

It hangs up fast. Tomorrow I will have to send a processes state, if it 
will be interesting for you. With my patch the kernel work fine. I added 
debug and found that it hangs up in the described case.
I suppose that my patch may be incorrect, but the problem exists and we 
should do something.

