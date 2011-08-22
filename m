Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1HVPtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:49:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39491 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1HVPtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
References: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
Date: Mon, 22 Aug 2011 11:49:44 -0400
Message-ID: <CACqU3MWx9Z+2dWP4OjVO+1T+3EsAE0geZhdRM2_B9osKw-Mw2A@mail.gmail.com>
Subject: Re: [PATCH 0/4] Kbuild/Kconfig
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

On Tue, Aug 16, 2011 at 1:34 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi Michal,
>
> The following small serie unexpose a few Kconfig variable from Kbuild, and
> vice-versa. The idea is that Kbuild is a user of Kconfig, not the other way
> around.
>
> In the same time, fix a couple of place where we hardcode the `.config' string.
>
> Comments Welcome !
>  - Arnaud
>
ping ?

 - Arnaud

> Arnaud Lacombe (4):
>  kbuild: introduce KBUILD_CONFIG; unexpose KCONFIG_CONFIG
>  kbuild: reduce kbuild invasivity within kconfig
>  kbuild: do not hardcode .config
>  kconfig: do not hardcode .config
>
>  Makefile                                |   20 ++++++++++++++------
>  arch/arm/boot/compressed/Makefile       |    2 +-
>  arch/unicore32/boot/compressed/Makefile |    2 +-
>  scripts/kconfig/Makefile                |   31 ++++++++++++++++---------------
>  4 files changed, 32 insertions(+), 23 deletions(-)
>
> --
> 1.7.6.153.g78432
>
>
