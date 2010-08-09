Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0HIOyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab0HIOyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:54:10 -0400
Date: Mon, 9 Aug 2010 11:53:58 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] perf symbols: ignore mapping symbols on ARM
Message-ID: <20100809145358.GE17509@ghostprotocols.net>
References: <1281352878-8735-1-git-send-email-dave.martin@linaro.org> <1281352878-8735-2-git-send-email-dave.martin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281352878-8735-2-git-send-email-dave.martin@linaro.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 09, 2010 at 12:21:18PM +0100, Dave Martin escreveu:
> +		/* Reject ARM ELF "mapping symbols": these aren't unique and
> +		 * don't identify functions, so will confuse the profile
> +		 * output: */
> +		if (ehdr.e_machine == EM_ARM) {
> +			if (!strcmp(elf_name, "$a") ||
> +			    !strcmp(elf_name, "$d") ||
> +			    !strcmp(elf_name, "$t"))
> +				continue;
> +		}
> +

Thanks, applied.
