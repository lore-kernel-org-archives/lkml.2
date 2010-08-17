Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0HQJxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:53:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab0HQJxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:53:17 -0400
Message-ID: <4C6A5B66.9040905@suse.cz>
Date: Tue, 17 Aug 2010 11:50:30 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fixes for using make 3.82
References: <4C6936120200007800010064@vpn.id2.novell.com>
In-Reply-To: <4C6936120200007800010064@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.8.2010 12:58, Jan Beulich wrote:
> It doesn't like pattern and explicit rules to be on the same line,
> and it seems to be more picky when matching file (or really directory)
> names with different numbers of trailing slashes.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  firmware/Makefile  |    2 +-
>  scripts/mkmakefile |    4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)

Thanks, applied with Cc: <stable@kernel.org>.

Michal
