Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1GRTED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:04:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46512 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1GRTEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:04:01 -0400
MIME-Version: 1.0
In-Reply-To: <1309571259-15241-1-git-send-email-lacombar@gmail.com>
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
	<1309571259-15241-1-git-send-email-lacombar@gmail.com>
Date: Mon, 18 Jul 2011 15:03:59 -0400
Message-ID: <CACqU3MVxiwmRQ9MQFAB9ymnTt3pEG+ZTAS5seQ7bgpetuafcMQ@mail.gmail.com>
Subject: Re: [RFC 0/7] Kconfig library check merge
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 1, 2011 at 9:47 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi Michal,
>
> You'll find hereafter a splitted-down version of my previous preliminary
> patch. I will eventually need to complete the second commit message, it is
> missing the purpose of the change, which AFAIR was a failure of something.
>
> Comments welcome!
>
>  - Arnaud
>
> Arnaud Lacombe (7):
>  kconfig/Makefile: add pretty printer for moc(1)
>  kconfig/Makefile: ensure `conf' appears last in `hostprogs-y'
>  kconfig/check.sh: prepare for generic check
>  kconfig: move QT checks to `scripts/kconfig/check.sh'
>  kconfig: move GTK checks to `scripts/kconfig/check.sh'
>  kconfig: move ncurses checks to `scripts/kconfig/check.sh'
>  kconfig: add stub for nconf checks
>
>  scripts/kconfig/Makefile                   |  155 +++++-----------------
>  scripts/kconfig/check.sh                   |  199 ++++++++++++++++++++++++++--
>  scripts/kconfig/lxdialog/check-lxdialog.sh |   84 ------------
>  3 files changed, 223 insertions(+), 215 deletions(-)
>
ping ?

 - Arnaud
