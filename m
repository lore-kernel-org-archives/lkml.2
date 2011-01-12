Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab1ALF4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:56:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52815 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab1ALF4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:56:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nkKTGWPEpS9io5zDZanmevb876Svd/NL3ocEvEG0OfZM2kTa3y47eyPRiJCEy2IuEx
         f4J7yLZAYC3mD9BSJ0j2jGmQAG81cCi5eis0F76h5ll4qIvr1pc3g3OasjrZLEvFXYBt
         jWC+hp5xG+etjZLogs2ypcoEFlRKItNq7V/SE=
Date: Tue, 11 Jan 2011 21:56:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 04/16] input: tnetv107x-touchscreen: don't treat NULL clk
 as an error
Message-ID: <20110112055640.GC22944@core.coreip.homeip.net>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
 <1294749833-32019-5-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294749833-32019-5-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:43:41PM +0000, Jamie Iles wrote:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
> 
> Cc: Cyril Chemparathy <cyril@ti.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Applied both, thank you Jamie.

-- 
Dmitry
