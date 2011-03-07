Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab1CGQRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:17:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab1CGQRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:17:43 -0500
Date: Mon, 7 Mar 2011 11:17:40 -0500
From: Andy Gospodarek <andy@greyhouse.net>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        Jay Vosburgh <fubar@us.ibm.com>, netdev@vger.kernel.org
Subject: Re: [V2 Patch] bonding: move procfs code into bond_procfs.c
Message-ID: <20110307161740.GT11864@gospo.rdu.redhat.com>
References: <1299484726-29905-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299484726-29905-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 03:58:46PM +0800, Amerigo Wang wrote:
> V2: Move #ifdef CONFIG_PROC_FS into bonding.h, as suggested by David.
> 
> bond_main.c is bloating, separate the procfs code out,
> move them to bond_procfs.c
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 

Looks good and works as expected.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>

