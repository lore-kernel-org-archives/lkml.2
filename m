Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0HCNBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:01:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724Ab0HCNBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:01:35 -0400
Message-ID: <4C5812E0.4060407@suse.cz>
Date: Tue, 03 Aug 2010 15:00:16 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: trivial@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Christoph Hellwig <hch@lst.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix a typo in a filename
References: <1280515401-13610-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1280515401-13610-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.7.2010 20:43, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  scripts/Makefile.modpost |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index 8f14c81..82a2420 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -30,7 +30,7 @@
>  #     - See include/linux/module.h for more details
>  
>  # Step 4 is solely used to allow module versioning in external modules,
> -# where the CRC of each module is retrieved from the Module.symers file.
> +# where the CRC of each module is retrieved from the Module.symvers file.

Applied.

Michal
