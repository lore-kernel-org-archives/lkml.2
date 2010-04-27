Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0D0Uia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:38:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51783 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab0D0Ui1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:38:27 -0400
Date: Tue, 27 Apr 2010 13:36:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Michal Marek <mmarek@suse.cz>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/6] kconfig: print symbol type in help text
Message-Id: <20100427133634.5c83f48e.randy.dunlap@oracle.com>
In-Reply-To: <4BD696CD.4090306@cn.fujitsu.com>
References: <4BD696C0.8050500@cn.fujitsu.com>
	<4BD696CD.4090306@cn.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BD74B19.000A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 15:48:29 +0800 Li Zefan wrote:

> [PATCH 2/6] menuconfig: improive help text a bit
> 
> Suggested-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  scripts/kconfig/mconf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 33f31eb..7ca6e8e 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -74,7 +74,7 @@ static const char mconf_readme[] = N_(
>  "\n"
>  "   Shortcut: Press <H> or <?>.\n"
>  "\n"
> -"o  To show hidden options, press <Z>.\n"
> +"o  To toggle the display of hidden options, press <Z>.\n"
>  "\n"
>  "\n"
>  "Radiolists  (Choice lists)\n"
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
