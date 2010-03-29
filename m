Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0C2SlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:41:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:53118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab0C2SlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:41:19 -0400
Message-ID: <4BB0F3F8.3090304@kernel.org>
Date: Mon, 29 Mar 2010 11:39:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: michael@ellerman.id.au, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, benh@kernel.crashing.org,
       torvalds@linux-foundation.org, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 20/31] lmb: Add __NOT_KEEP_LMB to put lmb code to .init
References: <1269830604-26214-21-git-send-email-yinghai@kernel.org>	<1269864470.24620.15.camel@concordia>	<4BB0D34C.7060509@kernel.org> <20100329.113449.174804111.davem@davemloft.net>
In-Reply-To: <20100329.113449.174804111.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 11:34 AM, David Miller wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Mon, 29 Mar 2010 09:20:28 -0700
> 
>> BTW, it seems only PowerPC need to keep lmb after init stage, right ?
> 
> For now.  Sparc64 will need it at some point in the future.

for memory hotplug support?

Yinghai
