Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1BIRKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:10:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:7349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1BIRKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:10:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,446,1291622400"; 
   d="scan'208";a="601010298"
Message-ID: <4D52CA98.2050100@linux.intel.com>
Date: Wed, 09 Feb 2011 09:10:48 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc4 (test_nx: BUG)
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com> <20110209090804.5c1ecf8e.randy.dunlap@oracle.com>
In-Reply-To: <20110209090804.5c1ecf8e.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/2011 9:08 AM, Randy Dunlap wrote:
> test_nx BUGs.
> CONFIG_DEBUG_RODATA=y
> (nearly allmodconfig, with a few changes)
>
> Is that expected?
>
this test should pass...
so something broke it (I'll call that a success for the test ;-)


