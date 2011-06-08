Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab1FHQDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:03:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:40821 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab1FHQDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:03:32 -0400
Message-ID: <4DEF9D52.1010909@suse.cz>
Date: Wed, 08 Jun 2011 18:03:30 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Random kconfig patches
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.6.2011 20:58, Arnaud Lacombe wrote:
> Hi Michal,
>
> You'll find hereafter a serie of relatively trivial (I hope) patches
> concerning kconfig. Mostly annotation, deadcode removal, and correctness.
> This serie is based on top of v3.0-rc1.
>
> As always, it is also available on my git repo on github:
>
>   git://github.com/lacombar/linux-2.6.git kconfig-trivial
>
> Regards,
>   - Arnaud
>
> Arnaud Lacombe (9):
>    kconfig: annotate non-trivial fall-trough
>    kconfig: fix return code for invalid boolean symbol in
>      conf_set_sym_val()
>    kconfig: add missing<stdarg.h>  inclusion
>    kconfig: add missing<ctype.h>  inclusion
>    kconfig: add missing<stdlib.h>  inclusion
>    kconfig: nuke reference to SWIG
>    kconfig: nuke LKC_DIRECT_LINK cruft
>    kconfig/gconf: kill deadcode
>    kconfig/gconf: silent missing prototype warnings

Thanks, pulled. I like especially the LKC_DIRECT_LINK removal :).

Michal
