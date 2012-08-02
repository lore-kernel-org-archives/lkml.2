Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2HBMbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:31:41 -0400
Received: from mail.tpi.com ([70.99.223.143]:3384 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab2HBMbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:31:39 -0400
Message-ID: <501A728A.2070905@canonical.com>
Date: Thu, 02 Aug 2012 06:28:58 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        ben@decadent.org.uk, JBottomley@Parallels.com,
        dan.j.williams@intel.com, divy@chelsio.com, netdev@vger.kernel.org
Subject: Re: [PATCH] firmware: Remove obsolete Chelsio cxgb3 firmware
References: <1343848670-31504-1-git-send-email-tim.gardner@canonical.com> <20120802.002000.2023014747210925552.davem@davemloft.net>
In-Reply-To: <20120802.002000.2023014747210925552.davem@davemloft.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 01:20 AM, David Miller wrote:
> 
> "git am" refuses to apply this to current 'net':
> 
> Applying: firmware: Remove obsolete Chelsio cxgb3 firmware
> error: removal patch leaves file contents
> error: firmware/cxgb3/t3fw-7.10.0.bin.ihex: patch does not apply
> 

Paul Gortmaker suggested I use 'git format-patch --irreversible-delete'
to produce shorter patches, but then even I can't reapply it.

How about a pull request against net-next instead ?

The following changes since commit 1a9b4993b70fb1884716902774dc9025b457760d:

  Merge branch 'upstream' of
git://git.linux-mips.org/pub/scm/ralf/upstream-linus (2012-08-01
16:47:15 -0700)

are available in the git repository at:


  git://kernel.ubuntu.com/rtg/net-next.git master

for you to fetch changes up to 044b722f36a17bc5f7f472cc3246cb15a430bb0e:

  firmware: Remove obsolete Chelsio cxgb3 firmware (2012-08-02 06:23:25
-0600)

----------------------------------------------------------------
Tim Gardner (1):
      firmware: Remove obsolete Chelsio cxgb3 firmware

 firmware/Makefile                   |    1 -
 firmware/cxgb3/t3fw-7.10.0.bin.ihex | 1935
-----------------------------------
 2 files changed, 1936 deletions(-)
 delete mode 100644 firmware/cxgb3/t3fw-7.10.0.bin.ihex
-- 
Tim Gardner tim.gardner@canonical.com
