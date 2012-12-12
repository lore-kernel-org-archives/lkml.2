Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2LLMjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:39:32 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57404 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2LLMjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:39:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAJSP0QXtZ=jMQp6YME4pCO0n90fPqbU7FQzPk4LsVvVjUQkc4Q@mail.gmail.com>
References: <1354273052-5203-1-git-send-email-laurent.navet@gmail.com>
	<1354273052-5203-2-git-send-email-laurent.navet@gmail.com>
	<CAJSP0QXtZ=jMQp6YME4pCO0n90fPqbU7FQzPk4LsVvVjUQkc4Q@mail.gmail.com>
Date: Wed, 12 Dec 2012 13:39:30 +0100
Message-ID: <CAH7P7Nh9uecdZfm7nQX59iENndue+HV0E4tR_Fyhj=uFfuNCSg@mail.gmail.com>
Subject: Re: [Line6linux-devel] [PATCH] staging: line6: pcm.c fix checkpatch issues
From: Laurent Navet <laurent.navet@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping ?

2012/11/30, Stefan Hajnoczi <stefanha@gmail.com>:
> Changes are fine.
>
> In the future, please split changes into individual patches.  For example:
> Patch 1 - Rename 'rv' to 'ret'
> Patch 2 - Replace decprecated simple_strtoul() with kstrtoint() in
> pcm_set_impulse_period()
> Patch 3 - Realign comment in line6_init_pcm() switch statement
>
> Keeping patches focussed on doing just one thing makes it easier to
> revert, bisect, and review them.
>
> Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
>

Should I split patches as suggested by Stefan ?

Laurent.
