Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1BIATH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:19:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:17917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab1BIATD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:19:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,444,1291622400"; 
   d="scan'208";a="705558865"
Message-ID: <57934.10.23.16.85.1297210741.squirrel@linux.intel.com>
In-Reply-To: <1297210637-5934-12-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
    <1297210637-5934-2-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-3-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-4-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-5-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-6-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-7-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-8-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-9-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-10-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-11-git-send-email-james_p_freyensee@linux.intel.com>
    <1297210637-5934-12-git-send-email-james_p_freyensee@linux.intel.com>
Date: Tue, 8 Feb 2011 16:19:01 -0800 (PST)
Subject: Re: [PATCH 12/12] n_tracerouter and n_tracesink Makefile addition.
From: james_p_freyensee@linux.intel.com
To: james_p_freyensee@linux.intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for this duplicate email; I think that was the email that I sent
yesterday of it finally going out :-/.

> From: J Freyensee <james_p_freyensee@linux.intel.com>
>
> This allows n_tracerouter and n_tracesink to be compiled in the
> Linux kernel.
>
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> ---
>  drivers/tty/Makefile |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
> index c43ef48..8c56ffd 100644
> --- a/drivers/tty/Makefile
> +++ b/drivers/tty/Makefile
> @@ -7,5 +7,7 @@ obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
>  obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
>  obj-$(CONFIG_N_GSM)		+= n_gsm.o
>  obj-$(CONFIG_R3964)		+= n_r3964.o
> +obj-$(CONFIG_TRACE_ROUTER)      += n_tracerouter.o
> +obj-$(CONFIG_TRACE_SINK)        += n_tracesink.o
>
>  obj-y				+= vt/
> --
> 1.6.6.1
>
>

