Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1GRSMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:12:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52188 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1GRSL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:11:58 -0400
MIME-Version: 1.0
In-Reply-To: <1310282853-14550-1-git-send-email-lacombar@gmail.com>
References: <1310282853-14550-1-git-send-email-lacombar@gmail.com>
Date: Mon, 18 Jul 2011 14:11:58 -0400
Message-ID: <CACqU3MVjnD4pqfOuq-wgoLdpFdTK_rdfd2WZTZU_7WCJL+1Tvg@mail.gmail.com>
Subject: Re: [PATCH] kconfig/nconf: remove useless conditionnal
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>,
        Nir Tzachar <nir.tzachar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 10, 2011 at 3:27 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> After the test
>
>        if (!submenu || ...)
>                continue;
>
> the variable `submenu' can _not_ be NULL, so do not test for this situation.
>
> Cc: Nir Tzachar <nir.tzachar@gmail.com>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  scripts/kconfig/nconf.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> index eb9e49d..6b189c8 100644
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
> @@ -1155,10 +1155,7 @@ static void conf(struct menu *menu)
>                active_menu = (struct menu *)item_data();
>                if (!submenu || !menu_is_visible(submenu))
>                        continue;
> -               if (submenu)
> -                       sym = submenu->sym;
> -               else
> -                       sym = NULL;
> +               sym = submenu->sym;
>
>                switch (res) {
>                case ' ':
Michal, ping ?

 - Arnaud

> --
> 1.7.3.4.574.g608b.dirty
>
>
