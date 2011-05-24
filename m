Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1EXTTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:19:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50926 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab1EXTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pMPxECp9gUjHobY0JYRF/K0F3Z8xeldhTTpzZ1VhcDnkXV4VACKX4pmZutFdfrMibb
         4nwSpi0BflUUzbM20h4khgV6lECCRyjxnRX9bODfxHGxFyumUQeXVfEEVctn7zqSE+wM
         R/6lYxGZBi8UXzSR8b42xgK+nZMYuRCWXOTGI=
Date: Tue, 24 May 2011 23:18:58 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: bleung@chromium.org, olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] power: bq20z75: support external notification
Message-ID: <20110524191858.GA17373@oksana.dev.rtsoft.ru>
References: <1306263960-1236-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1306263960-1236-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:05:59PM -0700, Rhyland Klein wrote:
> Adding support for external power change notification. One problem found
> is that there is a lag time before the sensor will return a new status. To
> ensure that we only fire off the power_supply_changed event when the status
> returned from the sensor is actually different, we delay sending the
> the notification, and instead poll on it looking for a change. The amount
> of time to poll is configurable via platform data.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
> v2:	removed the line enabling detection as it was not meant to be
> 	part of this patch.

1/2 and 2/2 applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
