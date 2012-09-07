Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab2IGXpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:45:40 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:49397 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751686Ab2IGXpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:45:38 -0400
Message-ID: <504A8707.8080507@xenotime.net>
Date: Fri, 07 Sep 2012 16:45:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2012-09-06-16-46 uploaded (fs/binfmt_aout)
References: <20120906234735.1B54B20004E@hpza10.eem.corp.google.com>
In-Reply-To: <20120906234735.1B54B20004E@hpza10.eem.corp.google.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 04:47 PM, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-09-06-16-46 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 


when CONFIG_COREDUMP is not enabled:

ERROR: "dump_seek" [fs/binfmt_aout.ko] undefined!
ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!

-- 
~Randy
