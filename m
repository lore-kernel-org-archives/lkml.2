Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2DLRPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:15:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:33026 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2DLRPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:15:50 -0400
Message-ID: <4F870DA0.4000807@windriver.com>
Date: Thu, 12 Apr 2012 13:15:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <tony@bakeyournoodle.com>, <mmarek@suse.cz>, <lacombar@gmail.com>
Subject: Re: [PATCH 3/5] drivers/net: remove IS_ENABLED usage from wiznet
 drivers
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>	<1334188257-3449-4-git-send-email-paul.gortmaker@windriver.com> <20120411.195444.540814653660043985.davem@davemloft.net>
In-Reply-To: <20120411.195444.540814653660043985.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-11 07:54 PM, David Miller wrote:
> From: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date: Wed, 11 Apr 2012 19:50:55 -0400
> 
>> The use of IS_ENABLED in C code (vs just in CPP #if directives)
>> causes us to carry the burden of a huge autoconf.h file.  It is
>> also misleading in that a casual inspection of the code would
>> leave one thinking that the if statements were evaluated at
>> runtime, when TX_FLOW is a Kconfig bool and hence evaluated
>> at configure time as an either/or.
>>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Want me to toss this into net-next?

Yes, that makes sense since wiznet only exists there currently.

Thanks,
Paul.
