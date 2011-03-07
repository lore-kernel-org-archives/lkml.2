Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1CGHt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:49:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1CGHtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:49:53 -0500
Date: Mon, 7 Mar 2011 08:49:50 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        Jay Vosburgh <fubar@us.ibm.com>, netdev@vger.kernel.org
Subject: Re: [V2 Patch] bonding: move procfs code into bond_procfs.c
Message-ID: <20110307074949.GA2792@psychotron.redhat.com>
References: <1299484726-29905-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299484726-29905-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Mar 07, 2011 at 08:58:46AM CET, amwang@redhat.com wrote:
>V2: Move #ifdef CONFIG_PROC_FS into bonding.h, as suggested by David.
>
>bond_main.c is bloating, separate the procfs code out,
>move them to bond_procfs.c
>
>Signed-off-by: WANG Cong <amwang@redhat.com>
>
>---
> drivers/net/bonding/Makefile      |    3 +
> drivers/net/bonding/bond_main.c   |  302 +------------------------------------
> drivers/net/bonding/bond_procfs.c |  276 +++++++++++++++++++++++++++++++++
> drivers/net/bonding/bonding.h     |   26 +++
> 4 files changed, 307 insertions(+), 300 deletions(-)
>

Looking good to me

Reviewed-by: Jiri Pirko <jpirko@redhat.com>

