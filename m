Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2EHRf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:35:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:5945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab2EHRfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:35:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138293336"
Message-ID: <4FA95976.9050900@linux.intel.com>
Date: Tue, 08 May 2012 10:35:50 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        tj@kernel.org, paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH] Expand memblock=debug to provide a bit more details
 (v1).
References: <1336157382-14548-1-git-send-email-konrad.wilk@oracle.com> <CAE9FiQWOps3Hmw=p6mWObRnu2KHVNshpoY+uWcAAQd1Yxi54yQ@mail.gmail.com> <20120504192459.GA5684@phenom.dumpdata.com>
In-Reply-To: <20120504192459.GA5684@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 12:24 PM, Konrad Rzeszutek Wilk wrote:
>>
>> that RET_IP is not very helpful for debugging.
> 
> Is there a better way of doing it that is automatic?
>>

It depends on what "it" is.  You could do a full stack backtrace, or use
__builtin_return_address(N).

	-hpa

