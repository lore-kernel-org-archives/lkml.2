Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0CaCez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:34:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:43924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab0CaCex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:34:53 -0400
Message-ID: <4BB2B4C1.5040603@kernel.org>
Date: Wed, 31 Mar 2010 11:34:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH -next] module.h: add stub for is_module_percpu_address
References: <20100330191834.f2009292.sfr@canb.auug.org.au> <4BB2358B.3090800@oracle.com>
In-Reply-To: <4BB2358B.3090800@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 31 Mar 2010 02:34:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 02:31 AM, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build for CONFIG_MODULES not enabled by providing a stub
> for is_module_percpu_address().
> 
> kernel/lockdep.c:605: error: implicit declaration of function 'is_module_percpu_address'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.  Applied to percpu tree.

-- 
tejun
