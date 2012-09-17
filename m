Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab2IQPrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:47:07 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:40936 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932205Ab2IQPrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:47:04 -0400
Message-ID: <505745CF.8040202@xenotime.net>
Date: Mon, 17 Sep 2012 08:46:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dave.kleikamp@oracle.com
Subject: Re: linux-next: Tree for Sept 17 (jfs)
References: <20120917215938.11c456c113ac3b015cb2d5ae@canb.auug.org.au>
In-Reply-To: <20120917215938.11c456c113ac3b015cb2d5ae@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 04:59 AM, Stephen Rothwell wrote:

> Hi all,
> 
> OK, so this was a bad one :-(
> 
> Changes since 201209014:
> 
> New tree: jfs
> 



on i386:

modular build:
ERROR: "__divdi3" [fs/jfs/jfs.ko] undefined!

or builtin:
fs/built-in.o: In function `dbDiscardAG':
(.text+0x12988b): undefined reference to `__divdi3'


-- 
~Randy
