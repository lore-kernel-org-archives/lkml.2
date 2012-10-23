Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2JWEkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:40:16 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:47157 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750810Ab2JWEkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:40:14 -0400
Message-ID: <50861FA9.2030506@xenotime.net>
Date: Mon, 22 Oct 2012 21:40:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2012-10-22-17-08 uploaded (memory_hotplug.c)
References: <20121023000924.C56EF5C0050@hpza9.eem.corp.google.com>
In-Reply-To: <20121023000924.C56EF5C0050@hpza9.eem.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 05:09 PM, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-10-22-17-08 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 



on x86_64, when CONFIG_MEMORY_HOTREMOVE is not enabled:

mm/built-in.o: In function `online_pages':
(.ref.text+0x10e7): undefined reference to `zone_pcp_reset'


-- 
~Randy
