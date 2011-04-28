Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1D1G0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:26:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65197 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab1D1G0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AFhLW2+LCm/RE7fhiX/1b8adUHrq0xaelzuJnVV/HWA2K1bDVOqVY8TpvwhRzetfuU
         /O6cAPPgLAzXf5p5trmr6eQMxXsui8Xc2Q5gyAMNWwls3JA+e2sXsp9gI3RwytJLkQZ0
         weph89WAZaaTN+7+fofYrjv9v25J557tvXjtw=
Date: Wed, 27 Apr 2011 23:26:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Timo =?iso-8859-1?Q?Ter=E4s?= <ext-timo.teras@nokia.com>,
        Tony Lindgren <tony@atomide.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: omap-keypad - fix a wrong free_irq() parameter
Message-ID: <20110428062612.GD31734@core.coreip.homeip.net>
References: <1303961006.8127.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303961006.8127.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 11:23:26AM +0800, Axel Lin wrote:
> In current implementation, free_irq() was using NULL rather than the
> driver data as the data pointer so free_irq() wouldn't have matched.
> 

Applied, thanks Axel.

-- 
Dmitry
