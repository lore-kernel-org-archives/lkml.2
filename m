Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423472Ab2LFMz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:55:29 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51341 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab2LFMz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:55:28 -0500
MIME-Version: 1.0
In-Reply-To: <1354792983-8120-1-git-send-email-snsehahn@cip.cs.fau.de>
References: <20121206070131.GL22569@mwanda>
	<1354792983-8120-1-git-send-email-snsehahn@cip.cs.fau.de>
Date: Thu, 6 Dec 2012 07:55:27 -0500
Message-ID: <CAHdPZaPGKPGDB-1=3KX3zrop9Hr42JB-GcD4F-wLKRi5SygqdQ@mail.gmail.com>
Subject: Re: [PATCH 3/6 v2] staging/rtl8192u: indent with tabs, not spaces
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Sebastian Hahn <snsehahn@cip.cs.fau.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, amwang@redhat.com,
        Jennifer.Naumann@informatik.stud.uni-erlangen.de, jkosina@suse.cz,
        linux-kernel@vger.kernel.org, Julia.Lawall@lip6.fr,
        yongjun_wei@trendmicro.com.cn, justinmattock@gmail.com,
        joe@perches.com, adam.buchbinder@gmail.com, dan.carpenter@oracle.com,
        linux-kernel@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>From the next time onward while you put a patch with updated code
change as mentioned by reviewers, you tell what changed in the next
interation.

like the below,

otherthan that your patch is good,

On Thu, Dec 6, 2012 at 6:23 AM, Sebastian Hahn <snsehahn@cip.cs.fau.de> wrote:
> Converted staging/rtl8187se to use tabs instead of spaces for
> indentation to fix the checkpatch error "code indent should use tabs
> where possible".
>
> Signed-off-by: Sebastian Hahn <snsehahn@cip.cs.fau.de>
> ---
V2:
    Removed .c.bak file as suggested by Dan.

>  drivers/staging/rtl8192u/ieee80211/ieee80211.h     |   14 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |  370 ++++++++++----------
>  .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    4 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |   14 +-
>  drivers/staging/rtl8192u/ieee80211/rtl_crypto.h    |   84 ++---
>  drivers/staging/rtl8192u/r8180_93cx6.c             |    2 +-
>  drivers/staging/rtl8192u/r8180_pm.h                |    2 +-
>  drivers/staging/rtl8192u/r8192U.h                  |  198 +++++------
>  drivers/staging/rtl8192u/r8192U_core.c             |   42 +--
>  9 files changed, 365 insertions(+), 365 deletions(-)
>

> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
