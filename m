Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2LFHDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:03:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35687 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2LFHDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:03:35 -0500
Date: Thu, 6 Dec 2012 10:01:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sebastian Hahn <snsehahn@cip.cs.fau.de>
Cc: gregkh@linuxfoundation.org,
        Jennifer.Naumann@informatik.stud.uni-erlangen.de,
        standby24x7@gmail.com, Julia.Lawall@lip6.fr, jkosina@suse.cz,
        joe@perches.com, yongjun_wei@trendmicro.com.cn,
        adam.buchbinder@gmail.com, amwang@redhat.com, justinmattock@gmail.com,
        wfp5p@virginia.edu, jim.cromie@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 3/6] staging/rtl8192u: indent with tabs, not spaces
Message-ID: <20121206070131.GL22569@mwanda>
References: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
 <1354740023-30849-4-git-send-email-snsehahn@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354740023-30849-4-git-send-email-snsehahn@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 09:40:20PM +0100, Sebastian Hahn wrote:
> Converted staging/rtl8187se to use tabs instead of spaces for
> indentation to fix the checkpatch error "code indent should use tabs
> where possible".
> 
> Signed-off-by: Sebastian Hahn <snsehahn@cip.cs.fau.de>
> ---
>  drivers/staging/rtl8192u/ieee80211/ieee80211.h     |   14 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |  370 ++++++++++----------
>  .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    4 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |   14 +-
>  drivers/staging/rtl8192u/ieee80211/rtl_crypto.h    |   84 ++---
>  drivers/staging/rtl8192u/r8180_93cx6.c             |    2 +-
>  drivers/staging/rtl8192u/r8180_93cx6.c.bak         |  146 ++++++++

You merged a .c.bak file into the kernel.

>  drivers/staging/rtl8192u/r8180_pm.h                |    2 +-
>  drivers/staging/rtl8192u/r8192U.h                  |  198 +++++------
>  drivers/staging/rtl8192u/r8192U_core.c             |   42 +--
>  10 files changed, 511 insertions(+), 365 deletions(-)

regards,
dan carpenter
