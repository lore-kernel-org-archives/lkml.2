Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab1KDRAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:00:22 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36475 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932807Ab1KDRAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:00:20 -0400
Message-ID: <4EB419F5.6070308@xenotime.net>
Date: Fri, 04 Nov 2011 09:59:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        x86 maintainers <x86@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for Nov 3 (KVMTOOL_TEST_ENABLE)
References: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au> <4EB33525.808@xenotime.net>
In-Reply-To: <4EB33525.808@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 05:43 PM, Randy Dunlap wrote:
> On 11/02/2011 11:20 PM, Stephen Rothwell wrote:
>> Hi all,
> 
> 
> When KVMTOOL_TEST_ENABLE is enabled but CONFIG_BLOCK is not enabled, there are
> MANY build errors.  This one (case) is probably fixed by adding "select BLOCK", but it's
> all rather ugly.

kconfig even tells us:

warning: (KVMTOOL_TEST_ENABLE) selects KGDB which has unmet direct dependencies (HAVE_ARCH_KGDB && DEBUG_KERNEL && EXPERIMENTAL)
warning: (KVMTOOL_TEST_ENABLE) selects BLK_DEV which has unmet direct dependencies (BLOCK)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
