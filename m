Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736Ab2EWP60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:58:26 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:60485 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933662Ab2EWP6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:58:06 -0400
Message-ID: <4FBD090E.5020901@xenotime.net>
Date: Wed, 23 May 2012 08:58:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: linux-next: Tree for May 23 (uml)
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
In-Reply-To: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 12:07 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120522:



uml defconfig on x86_64:

arch/um/kernel/process.c: In function 'interrupt_end':
arch/um/kernel/process.c:122:14: error: 'struct task_struct' has no member named 'replacement_session_keyring'
arch/um/kernel/process.c:123:4: error: implicit declaration of function 'key_replace_session_keyring'

-- 

~Randy
