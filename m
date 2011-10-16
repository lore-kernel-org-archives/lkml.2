Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab1JPSod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 14:44:33 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:47988 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752081Ab1JPSoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 14:44:32 -0400
Message-ID: <4E9B260E.2020308@xenotime.net>
Date: Sun, 16 Oct 2011 11:44:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: gcc: arch/x86/lib/memmove_64.c: No such file or directory
References: <CAHnt0GWbGRjA+8BC1hRgYPL625S+3kZH2b0UgpC+-CD=3BO3Sg@mail.gmail.com>
In-Reply-To: <CAHnt0GWbGRjA+8BC1hRgYPL625S+3kZH2b0UgpC+-CD=3BO3Sg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 11:51 PM, Peter Teoh wrote:
> After a git pull today, when compiling linus git tree:
> 
> (both instance below consistently gave error)
> 
> git describe
> v3.1-rc9-73-g37cf951
> 
> git describe
> v3.1-rc9-85-ge9308cf
> 
> gcc: arch/x86/lib/memmove_64.c: No such file or directory
> gcc: no input files
> make[1]: *** [arch/x86/lib/memmove_64.o] Error 1
> make: *** [arch/x86/lib] Error 2
> 
> cat include/config/kernel.release
> 3.1.0-rc9+
> 
> .config file as per attached,   thanks.

No problem here with v3.1-rc9-87-g4c41042
and your .config file.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
