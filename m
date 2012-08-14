Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2HNC7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:59:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:6148 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145Ab2HNC7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:59:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,763,1336374000"; 
   d="scan'208";a="180665649"
Message-ID: <5029BF28.5030101@intel.com>
Date: Mon, 13 Aug 2012 19:59:52 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: nhorman@tuxdriver.com, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v1 1/2] net: netprio: fix files lock and remove useless
 d_path bits
References: <20120814013939.3144.13167.stgit@jf-dev1-dcblab> <20120814022951.GF23464@ZenIV.linux.org.uk>
In-Reply-To: <20120814022951.GF23464@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2012 7:29 PM, Al Viro wrote:
> On Mon, Aug 13, 2012 at 06:39:39PM -0700, John Fastabend wrote:
>> -			path = d_path(&file->f_path, tmp, PAGE_SIZE);
>
> What's using tmp after that patch and do you still need to bother
> allocating it?
>

nothing removed it in v2.
