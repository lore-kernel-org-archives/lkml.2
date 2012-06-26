Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2FZKSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:18:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab2FZKSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:18:41 -0400
Message-ID: <4FE98C7C.4030303@suse.cz>
Date: Tue, 26 Jun 2012 12:18:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] kbuild: move definitions from top-level Makefile
 to scripts/Kbuild.config
References: <20120505080640.GA13773@merkur.ravnborg.org> <1336205926-13946-5-git-send-email-sam@ravnborg.org>
In-Reply-To: <1336205926-13946-5-git-send-email-sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.5.2012 10:18, Sam Ravnborg wrote:
> diff --git a/scripts/Kbuild.config b/scripts/Kbuild.config
> new file mode 100644
> index 0000000..15d5b1e
> --- /dev/null
> +++ b/scripts/Kbuild.config
> @@ -0,0 +1,68 @@
[...]
> +ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
> +KBUILD_CFLAGS += -Os
> +else
> +KBUILD_CFLAGS += -O2
> +endif

This duplicates the statement in the top-level Makefile and does not
work in this context, because auto.conf is not included yet.

Michal
