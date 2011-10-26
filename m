Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab1JZS0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 14:26:20 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:39379 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932733Ab1JZS0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 14:26:19 -0400
Message-ID: <4EA850C1.4060405@xenotime.net>
Date: Wed, 26 Oct 2011 11:26:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: linux-next: Tree for Oct 25 (mfd/ab8500)
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
In-Reply-To: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/11 02:36, Stephen Rothwell wrote:
> Hi all,


drivers/mfd/ab8500-core.c:881:7: error: 'AB8500_CUT3P3' undeclared


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
