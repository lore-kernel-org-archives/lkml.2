Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0CVTeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:34:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:37444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab0CVTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:34:05 -0400
Message-ID: <4BA7C5D3.2040804@kernel.org>
Date: Mon, 22 Mar 2010 12:32:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 19/20] x86/pci: ioh new version read all at same time
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>	<1269155601-18247-20-git-send-email-yinghai@kernel.org> <20100322091620.5aebf353@jbarnes-piketon>
In-Reply-To: <20100322091620.5aebf353@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 09:16 AM, Jesse Barnes wrote:
> On Sun, 21 Mar 2010 00:13:20 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> also it will add back default range to legacy IOH
>>
> 
> This patch is a bit short on details.  Are we fixing a real bug here
> that _CRS fails to cover?  Or is it just for debug purposes?
> 

yes for debug purpose. anyway BIOS need to keep them the same.

one from HW register reading, and one from acpi.

Yinghai
