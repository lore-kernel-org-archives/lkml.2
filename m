Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1HDBx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:53:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40594 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab1HDBxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:53:50 -0400
MIME-Version: 1.0
In-Reply-To: <1312422727-9740-1-git-send-email-lacombar@gmail.com>
References: <1312422727-9740-1-git-send-email-lacombar@gmail.com>
Date: Wed, 3 Aug 2011 21:53:49 -0400
Message-ID: <CACqU3MVEk0vdtgjq9nnP=7hTnsNkb-_MU-2O=vzHUmKuDQNrvg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kconfig/nconf: nuke unreferenced `nohelp_text'
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 3, 2011 at 9:52 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> After commit 5416857867c9cc94aba641898c567d9707de30f1, 1nohelp_text' is no
                                                         ^
this should read `nohelp_text', sorry for the typo :/

 - Arnaud

> longer referenced, nuke it.
>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  scripts/kconfig/nconf.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> index 39ca1f1..b113c50 100644
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
> @@ -182,8 +182,6 @@ setmod_text[] = N_(
>  "This feature depends on another which\n"
>  "has been configured as a module.\n"
>  "As a result, this feature will be built as a module."),
> -nohelp_text[] = N_(
> -"There is no help available for this option.\n"),
>  load_config_text[] = N_(
>  "Enter the name of the configuration file you wish to load.\n"
>  "Accept the name shown to restore the configuration you\n"
> --
> 1.7.6.153.g78432
>
>
