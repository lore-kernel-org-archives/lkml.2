Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1CIVeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:34:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37838
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab1CIVeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:34:01 -0500
Date: Wed, 09 Mar 2011 13:34:39 -0800 (PST)
Message-Id: <20110309.133439.246540302.davem@davemloft.net>
To: andy@greyhouse.net
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, fubar@us.ibm.com,
        netdev@vger.kernel.org
Subject: Re: [V2 Patch] bonding: move procfs code into bond_procfs.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110307161740.GT11864@gospo.rdu.redhat.com>
References: <1299484726-29905-1-git-send-email-amwang@redhat.com>
	<20110307161740.GT11864@gospo.rdu.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Gospodarek <andy@greyhouse.net>
Date: Mon, 7 Mar 2011 11:17:40 -0500

> On Mon, Mar 07, 2011 at 03:58:46PM +0800, Amerigo Wang wrote:
>> V2: Move #ifdef CONFIG_PROC_FS into bonding.h, as suggested by David.
>> 
>> bond_main.c is bloating, separate the procfs code out,
>> move them to bond_procfs.c
>> 
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> 
> 
> Looks good and works as expected.
> 
> Signed-off-by: Andy Gospodarek <andy@greyhouse.net>

Applied, thanks everyone.
