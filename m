Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab2ANXHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 18:07:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab2ANXHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 18:07:00 -0500
Message-ID: <4F120A97.6050209@suse.cz>
Date: Sun, 15 Jan 2012 00:07:03 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Artem@mgw2.diku.dk, Bityutskiy@suse.de
Subject: Re: [PATCH v2] scripts/coccinelle: improve the coverage of some semantic
 patches
References: <1326580914-20464-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1326580914-20464-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.1.2012 23:41, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> This patch ensures that all semantic patches in the scripts/coccinelle
> directory provide the report option.  Report messages that include line
> numbers now have the line number preceded by "line" for easier subsequent
> processing.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  scripts/coccinelle/api/kstrdup.cocci      |   75 ++++++++++++++++++++++++++++--
>  scripts/coccinelle/api/memdup.cocci       |   34 ++++++++++++-
>  scripts/coccinelle/api/memdup_user.cocci  |   39 ++++++++++++---
>  scripts/coccinelle/free/kfree.cocci       |   14 +++--
>  scripts/coccinelle/iterators/fen.cocci    |   73 ++++++++++++++++++++++++++---
>  scripts/coccinelle/iterators/itnull.cocci |   54 ++++++++++++++++++---
>  scripts/coccinelle/locks/call_kern.cocci  |   67 +++++++++++++++++++-------
>  scripts/coccinelle/locks/flags.cocci      |   12 ++--
>  scripts/coccinelle/locks/mini_lock.cocci  |   15 +++---
>  scripts/coccinelle/misc/doubleinit.cocci  |    8 +--
>  scripts/coccinelle/null/eno.cocci         |   36 ++++++++++++--
>  11 files changed, 351 insertions(+), 76 deletions(-)

This looks much better, thanks. Applied to kbuild.git#misc.

Michal
