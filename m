Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab2HBUmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:42:12 -0400
Received: from mail1.windriver.com ([147.11.146.13]:58121 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2HBUmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:42:10 -0400
Message-ID: <501AE5D9.7000805@windriver.com>
Date: Thu, 2 Aug 2012 16:40:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <ben@decadent.org.uk>, <JBottomley@parallels.com>,
        <dan.j.williams@intel.com>, <divy@chelsio.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] firmware: Remove obsolete Chelsio cxgb3 firmware
References: <1343848670-31504-1-git-send-email-tim.gardner@canonical.com> <20120802.002000.2023014747210925552.davem@davemloft.net> <501A728A.2070905@canonical.com>
In-Reply-To: <501A728A.2070905@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-02 08:28 AM, Tim Gardner wrote:
> On 08/02/2012 01:20 AM, David Miller wrote:
>>
>> "git am" refuses to apply this to current 'net':
>>
>> Applying: firmware: Remove obsolete Chelsio cxgb3 firmware
>> error: removal patch leaves file contents
>> error: firmware/cxgb3/t3fw-7.10.0.bin.ihex: patch does not apply
>>
> 
> Paul Gortmaker suggested I use 'git format-patch --irreversible-delete'
> to produce shorter patches, but then even I can't reapply it.

The git folks originally designed it that way on purpose, (i.e. used
for review only) but it doesn't really need to be limited like that,
so I've proposed a fix and we'll see what the git folks have to say.

   http://marc.info/?l=git&m=134394003916648&w=2

Paul.
--

> 
> How about a pull request against net-next instead ?
> 
> The following changes since commit 1a9b4993b70fb1884716902774dc9025b457760d:
> 
>   Merge branch 'upstream' of
> git://git.linux-mips.org/pub/scm/ralf/upstream-linus (2012-08-01
> 16:47:15 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://kernel.ubuntu.com/rtg/net-next.git master
> 
> for you to fetch changes up to 044b722f36a17bc5f7f472cc3246cb15a430bb0e:
> 
>   firmware: Remove obsolete Chelsio cxgb3 firmware (2012-08-02 06:23:25
> -0600)
> 
> ----------------------------------------------------------------
> Tim Gardner (1):
>       firmware: Remove obsolete Chelsio cxgb3 firmware
> 
>  firmware/Makefile                   |    1 -
>  firmware/cxgb3/t3fw-7.10.0.bin.ihex | 1935
> -----------------------------------
>  2 files changed, 1936 deletions(-)
>  delete mode 100644 firmware/cxgb3/t3fw-7.10.0.bin.ihex
> 
