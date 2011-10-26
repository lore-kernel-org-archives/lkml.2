Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab1JZSj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 14:39:56 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:36375 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932788Ab1JZSjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 14:39:54 -0400
Message-ID: <4EA853F2.4040503@xenotime.net>
Date: Wed, 26 Oct 2011 11:39:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 25 (target)
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

target_core_cdb.c needs to include <linux/export.h>:

drivers/target/target_core_cdb.c:1316:1: warning: data definition has no type or storage class [enabled by default]
drivers/target/target_core_cdb.c:1316:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/target/target_core_cdb.c:1316:1: warning: parameter names (without types) in function declaration [enabled by default]


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
