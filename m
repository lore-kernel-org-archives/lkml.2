Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2DBPcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:32:36 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:59962 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751648Ab2DBPce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:32:34 -0400
Message-ID: <4F79C68C.1070100@xenotime.net>
Date: Mon, 02 Apr 2012 08:32:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: linux-next: Tree for Apr 2 (uml)
References: <20120402135538.502e6c73f0cb3e6ae0b3436f@canb.auug.org.au>
In-Reply-To: <20120402135538.502e6c73f0cb3e6ae0b3436f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 08:55 PM, Stephen Rothwell wrote:

> Hi all,
> 
> The merge window has closed, so -next is open for busniess.
> 
> Changes since 20120330:



uml defconfig on x86_64:

  CC      arch/um/drivers/mconsole_kern.o
arch/um/drivers/mconsole_kern.c: In function 'stack_proc':
arch/um/drivers/mconsole_kern.c:707:2: error: implicit declaration of function 'switch_to'
make[2]: *** [arch/um/drivers/mconsole_kern.o] Error 1


-- 
~Randy
