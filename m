Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0HPMkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:40:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:50945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab0HPMkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:40:40 -0400
Message-ID: <4C6931C4.4000505@suse.cz>
Date: Mon, 16 Aug 2010 14:40:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Hendry <andrew.hendry@gmail.com>
Cc: Yegor Yefremov <yegorslists@googlemail.com>,
        Roland McGrath <roland@redhat.com>, Roland Dreier <rdreier@cisco.com>,
        Tiago Maluta <tiago.maluta@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>	<20100621120613.86cad1a4.akpm@linux-foundation.org>	<4C1FC35C.8090201@suse.cz>	<AANLkTil2-YNAa-jyOYD4cNtbJQ1XQJ6-v3iJ6wxpz7br@mail.gmail.com>	<AANLkTinC6Sqs7W--=14nmJFDcTS4HQn0=ysn7VhYDDX6@mail.gmail.com>	<adaocdg3fng.fsf@roland-alpha.cisco.com>	<20100805222623.39A3240208@magilla.sf.frob.com>	<AANLkTikvRqTR6TjP9H4-_RHhax24YRPv9PCxn165RTWs@mail.gmail.com>	<4C613627.1090907@suse.cz> <AANLkTimncLdNZCcpcEi9M7-jCuw5FE+xDT7v5--ByfMn@mail.gmail.com>
In-Reply-To: <AANLkTimncLdNZCcpcEi9M7-jCuw5FE+xDT7v5--ByfMn@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 16.8.2010 14:35, Andrew Hendry napsal(a):
> This gives some errors on my ubuntu build for -rc1, reverting lets it
> build normally. Am I missing something?
> 
> ahendry@ubuntu:~/linux/linux-2.6$ make
> make: ngcc: Command not found
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      kernel/bounds.s
> /bin/sh: ngcc: not found
> make[1]: *** [kernel/bounds.s] Error 127
> make: *** [prepare0] Error 2
> 
> .config has CONFIG_CROSS_COMPILE="n"

CONFIG_CROSS_COMPILE is a string option, leave it empty if you are not
cross compiling.

Michal.
