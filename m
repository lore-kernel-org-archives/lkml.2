Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0DNXth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:49:37 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:21131 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab0DNXtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:49:23 -0400
Date: Wed, 14 Apr 2010 16:48:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 5/6] menuconfig: add support to show hidden options
 which have prompts
Message-Id: <20100414164839.e3c9391d.randy.dunlap@oracle.com>
In-Reply-To: <4BC53A7A.5080502@cn.fujitsu.com>
References: <4BC539DD.5040003@cn.fujitsu.com>
	<4BC53A7A.5080502@cn.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BC65475.0010:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 11:46:02 +0800 Li Zefan wrote:

> Usage:
>   Press <Z> to show all config symbols which have prompts.

to show or unshow (toggle) all config symbols which have prompts.

Nice and helpful, yes, thanks.


> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 8413cf3..33f31eb 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -67,13 +67,15 @@ static const char mconf_readme[] = N_(
>  "             there is a delayed response which you may find annoying.\n"
>  "\n"
>  "   Also, the <TAB> and cursor keys will cycle between <Select>,\n"
> -"   <Exit> and <Help>\n"
> +"   <Exit> and <Help>.\n"
>  "\n"
>  "o  To get help with an item, use the cursor keys to highlight <Help>\n"
> -"   and Press <ENTER>.\n"
> +"   and press <ENTER>.\n"
>  "\n"
>  "   Shortcut: Press <H> or <?>.\n"
>  "\n"
> +"o  To show hidden options, press <Z>.\n"

maybe:
       To toggle the display of hidden options, press <Z>.
or     To alternate the ...
?

> +"\n"
>  "\n"
>  "Radiolists  (Choice lists)\n"
>  "-----------\n"

---
~Randy
