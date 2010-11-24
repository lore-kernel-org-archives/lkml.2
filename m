Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0KXIdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:33:32 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59262 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab0KXIdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:33:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Jx1vJ4ViOq6F2rn3NrHf9RoI+C8yEzQkSOYfsS97N1E8QhLbfLsxyk/QfDBBwoaOk/
         O1NhAp+VcXW2yka7LG0/8kkAWDpLAuqX54IHOIbZL6dM9Fg4i/LdfO/NUkq7gQdA3mkx
         wvRRYln+SXrcbneLQohcxvtzMGlRpCba5VpKY=
Date: Wed, 24 Nov 2010 10:33:45 +0200
From: Jarkko Nikula <jhnikula@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arun KS <arunks@mistralsolutions.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] ASoC: Fix resource reclaim for osk5912
Message-Id: <20101124103345.36db8f6f.jhnikula@gmail.com>
In-Reply-To: <1290583400.20639.3.camel@mola>
References: <1290583248.20639.1.camel@mola>
	<1290583400.20639.3.camel@mola>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010 15:23:20 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/omap/osk5912.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
Good catches,

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
