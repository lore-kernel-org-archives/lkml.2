Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab1ARMJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 07:09:21 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:50315 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1ARMJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 07:09:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RrSzWtNib/H+VlNdjhpilNYsjyMK4npgX1RHkW8iHRsNa+QQQmiP+ct1dw3yO9uIGd
         s7kcIsInyH3YNn6ORwWV2LWRLWHbmIkQURctPMxeqE34T3+zeZrDjXvu5JYUuautnAqe
         PueSVme0oScahXz9/veMOqw8dRw+4jqJBErDc=
Subject: Re: [PATCH 12/16] mtd: mpc5121_nfc: don't treat NULL clk as an
 error
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Vincent Sanders <support@simtec.co.uk>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1294749833-32019-13-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
	 <1294749833-32019-13-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 14:09:13 +0200
Message-ID: <1295352553.2470.132.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 12:43 +0000, Jamie Iles wrote:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
> 
> Cc: Vincent Sanders <support@simtec.co.uk>
> Cc: linux-mtd@lists.infradead.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

