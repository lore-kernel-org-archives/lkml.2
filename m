Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0C2UOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:14:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51030 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab0C2UO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iZXcoU7qXeuX6AY0/5XjVjXxvB3dFr7VmX+M2t9qIY0L/7PO8YEE7oMOgva3YlIaHW
         MVlA2b7VY6iM8wGa/JImBMZzK4yAQdB6ht8Uv+LvUsXTgzHgSF8sByiYhlIKLsXN3H7G
         kAbdbxY8JpOvHwUMlCxRrnlz3VNuoIIXuzcPU=
Message-ID: <4BB10A21.9080602@pobox.com>
Date: Mon, 29 Mar 2010 16:14:25 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] libata: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org> <1269885165-18617-16-git-send-email-tj@kernel.org>
In-Reply-To: <1269885165-18617-16-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 01:52 PM, Tejun Heo wrote:
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Stephen Rothwell<sfr@canb.auug.org.au>
> Cc: Jeff Garzik<jgarzik@pobox.com>
> ---
>   drivers/ata/ahci_platform.c |    1 +
>   drivers/ata/libahci.c       |    1 +
>   2 files changed, 2 insertions(+), 0 deletions(-)

Unless you object, I'll go ahead and apply this to #upstream...


