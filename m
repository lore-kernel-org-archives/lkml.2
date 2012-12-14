Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab2LNPVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:21:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab2LNPVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:21:30 -0500
Message-ID: <50CB43F4.2000908@suse.cz>
Date: Fri, 14 Dec 2012 16:21:24 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/1] scripts/config: Fix wrong "shift" for --keep-case
References: <1355467682-17217-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1355467682-17217-1-git-send-email-hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.12.2012 07:47, Hiroshi Doyu wrote:
> Remove wrong "shift" for --keep-case. There is always "shift" at
> beginning of while-loop. No need "shift" at --keep-case just before
> "continue" to process next argument.
> 
> Now the following works as expected:
> 
> ./scripts/config -e aAa -k -e bBb -e cCc && tail -3 .config
> CONFIG_AAA=y
> CONFIG_bBb=y
> CONFIG_cCc=y
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>

Applied to kbuild.git#misc, thanks.

Michal
