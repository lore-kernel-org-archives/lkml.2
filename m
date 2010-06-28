Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0F1LoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:44:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62085 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0F1LoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rZfDOLcJnB6EfC1Ct3xseHI0uknAy0RgJd76UJ0WFwUbev6KG9Ofb3UXdwWdEaYLZu
         6B0UvZO6xwp6F7U/9YogSIXohrw2MPKraGYZg7Q6lMOvhYAE3SrclScpCSGYmt0dhUf4
         I7XyyTzX2i+zJVdBZZ/tnhke3dicMVFoG5xyY=
Date: Mon, 28 Jun 2010 15:43:54 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH v2 24/26] power: Add JZ4740 battery driver.
Message-ID: <20100628114354.GA21096@oksana.dev.rtsoft.ru>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
 <1276924111-11158-25-git-send-email-lars@metafoo.de>
 <4C26B05C.3030706@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4C26B05C.3030706@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 03:58:52AM +0200, Lars-Peter Clausen wrote:
> Hi Anton
> 
> You already said that v1 of the patch looked good to you. There are some minor
> modifications in v2 due to code re-factoring of the ADC driver. If you think this
> version is good as well an Acked-By would be nice :)

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks,

> Lars-Peter Clausen wrote:
> > This patch adds support for the battery voltage measurement part of the JZ4740
> > ADC unit.
> > 
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> > 
> > ---
> > Changes since v1
> > - Fix voltage difference check in jz_update_battery
> > - Move get_battery_voltage from the hwmon driver to the battery driver
> > - The battery driver is now a cell of the ADC MFD driver
> > ---

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
