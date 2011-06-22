Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1FVFEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 01:04:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55697 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1FVFEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 01:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=FQICeKdxFTv22FqLCLPZKs7DMw7bMe+Z/i6pDunJ0e+COJ3vsTYMoABhV3JG0mU4K+
         vPcxnTsskdoAbk/ZBHykFfAGxct6tRnf02bKhmLFKqOPjVWy6/RLc83iHkzfyjYgXIGv
         +8KzimdY/ZOG0lq1WanEBj2qPcxidLhjFgCtY=
Subject: Re: [PATCH] mtd: onenand: remove redundant mtd_device_unregister
 before onenand_release
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Date: Wed, 22 Jun 2011 08:05:04 +0300
In-Reply-To: <1308308793.2628.0.camel@phoenix>
References: <1308308793.2628.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308719109.18119.29.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 19:06 +0800, Axel Lin wrote:
> onenand_release() will call mtd_device_unregister(), thus remove the redundant
> mtd_device_unregister() call before onenand_release().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy

