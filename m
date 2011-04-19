Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1DSG6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:58:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:56113 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1DSG6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:58:09 -0400
Message-ID: <4DAD327B.4030904@suse.cz>
Date: Tue, 19 Apr 2011 08:58:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: LOCALVERSION in setlocalversion
References: <BANLkTikYuYVvXiHvi_kr2H7n29k=veThtw@mail.gmail.com>
In-Reply-To: <BANLkTikYuYVvXiHvi_kr2H7n29k=veThtw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.4.2011 08:42, Haojian Zhuang wrote:
> In scripts/setlocalversion under linux kernel tree, the scripts seems
> a little strange.
[...]
>         # append a plus sign if the repository is not in a clean
>         # annotated or signed tagged state (as git describe only
>         # looks at signed or annotated tags - git tag -a/-s) and
>         # LOCALVERSION= is not specified
>         if test "${LOCALVERSION+set}" != "set"; then
>                 scm=$(scm_version --short)
>                 res="$res${scm:++}"
>         fi
> fi
> 
> LOCALVERSION isn't assigned in any place. Only CONFIG_LOCALVERSION
> can be assigned in .config file.
> Why do we need to check LOCALVERSION at here?

It can be set on the commandline:

make LOCALVERSION=something

Michal
