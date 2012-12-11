Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2LKNkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:40:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab2LKNkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:40:47 -0500
Message-ID: <50C737DC.9070307@suse.cz>
Date: Tue, 11 Dec 2012 14:40:44 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] scripts/tags.sh: Support compiled source
References: <1355152306-4513-1-git-send-email-js1304@gmail.com> <1355152306-4513-2-git-send-email-js1304@gmail.com>
In-Reply-To: <1355152306-4513-2-git-send-email-js1304@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 10.12.2012 16:11, Joonsoo Kim napsal(a):
> We usually have interst in compiled files only,
> because they are strongly related to individual's work.
> Current tags.sh can't select compiled files, so support it.
> 
> We can use this functionality like below.
> "make cscope O=. SRCARCH=xxxx COMPILED_SOURCE=compiled"
> 
> It must be executed after building the kernel.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> ---
> v2: change bash specific '[[]]' to 'case in' statement.
>     use COMPILED_SOURCE env var, instead of abusing SUBARCH
> v3: change [ "$COMPILED_SOURCE"="compiled" ] to [ -n $COMPILED_SOURCE" ]

Thanks, I applied both patches to kbuild.git#misc now.

Michal

