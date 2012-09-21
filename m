Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab2IUPX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:23:56 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:55404 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754880Ab2IUPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:23:54 -0400
Message-ID: <505C865D.5090802@xenotime.net>
Date: Fri, 21 Sep 2012 08:23:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: mmotm 2012-09-20-17-25 uploaded (fs/bimfmt_elf on uml)
References: <20120921002638.7859F100047@wpzn3.hot.corp.google.com>
In-Reply-To: <20120921002638.7859F100047@wpzn3.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 05:26 PM, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-09-20-17-25 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 


on uml for x86_64 defconfig:

fs/binfmt_elf.c: In function 'fill_files_note':
fs/binfmt_elf.c:1419:2: error: implicit declaration of function 'vmalloc'
fs/binfmt_elf.c:1419:7: warning: assignment makes pointer from integer without a cast
fs/binfmt_elf.c:1437:5: error: implicit declaration of function 'vfree'


-- 
~Randy
