Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab0KROmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:42:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42623 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563Ab0KROmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b9/pJHTrR4yeubmNkJigKyhJ1IxM19QSWKYVJyVjucYgZqb0Pdvyrx4iVqK/JXc5rv
         BSdsrTF4fWqWayoTOJUfmyo/AuHu6UAqCnOBd07FHKUk21h3vemf++L1Vsd1b7xhavi8
         WrEKnpPLUQJt/hcWArA00Se422aQXDrFC7wvQ=
Date: Thu, 18 Nov 2010 17:42:09 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: rklein@nvidia.com, broonie@opensource.wolfsonmicro.com, achew@nvidia.com,
        olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
Message-ID: <20101118144209.GA17323@oksana.dev.rtsoft.ru>
References: <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <1287676501-23254-1-git-send-email-lars@metafoo.de>
 <20101118140522.GD19527@oksana.dev.rtsoft.ru>
 <4CE53871.6080004@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CE53871.6080004@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:30:09PM +0100, Lars-Peter Clausen wrote:
[..]
> > But please, look at Mark Brown comments. If they are still
> > applicable, the follow up patch would be great.
> 
> Hi
> 
> I'll send a follow up patch later today. I think I had one or two other issues on my
> list that need to be addressed.
> I wanted to wait with v3 until it was clear whether the driver had a chance to be
> merged at all.
> Do you prefer a v3 of the original patch or an incremental one?

Incremental would be fine, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
