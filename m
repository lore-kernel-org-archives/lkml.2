Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab2FVLcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:32:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab2FVLcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:32:08 -0400
Message-ID: <4FE457A1.2020509@draigBrady.com>
Date: Fri, 22 Jun 2012 12:31:45 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ysato@users.sourceforge.jp
Subject: Re: finding unused header files
References: <alpine.DEB.2.02.1206220641150.6493@oneiric>
In-Reply-To: <alpine.DEB.2.02.1206220641150.6493@oneiric>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 11:46 AM, Robert P. J. Day wrote:
> 
>   inspired by that last post that located an unused header file under
> arch/h8300, i ran my "find_unused_headers.sh" script on the same
> sub-directory to see what would show up.
> 
>   the script is stupidly conservative and didn't identify that shm.h
> header since *somewhere* in the entire kernel source tree, someone was
> including a file called "shm.h" -- not even for the same architecture.
> like i said, stupidly conservative.
> 
>   but it did find this:
> 
> $ ../s/find_unused_headers.sh arch/h8300
> ===== target_time.h =====
> ./arch/h8300/include/asm/target_time.h
> $
> 
> and i see nothing anywhere in the entire tree that includes a
> target_time.h header under any circumstances.
> 
>   i should probably do another run of these scripts some day, just to
> see what turns up.
> 
> rday
> 

See also:
http://code.google.com/p/include-what-you-use/

It's quite awkward (relies on a llvm/clang source tree for example)
and currently requires human interpretation.

cheers,
Pádraig.
