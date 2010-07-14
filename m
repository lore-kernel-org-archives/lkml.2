Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab0GNWoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:44:01 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46585 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756571Ab0GNWn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:43:59 -0400
Date: Wed, 14 Jul 2010 15:24:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>
Cc: Dave Airlie <airlied@redhat.com>, Timothy Meade <zt.tmzt@gmail.com>,
        linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: Closed source userspace graphics drivers with an open source
 kernel component
Message-ID: <20100714132434.GC3103@ucw.cz>
References: <1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
 <AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>
 <1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com>
 <AANLkTilEKPmHKNDNbNpmUvcYC338YezLkNBc4ShfTFdp@mail.gmail.com>
 <4C2D3066.9040104@codeaurora.org>
 <AANLkTilsqmCZwLUNJhvDKkralHQZzlRV3ZxaIGbt9-xB@mail.gmail.com>
 <AANLkTinvzJrx4AqgWYuMg66Djf-snouLQZE7wI9Bu0Kv@mail.gmail.com>
 <AANLkTimiNKRabIDCLvRwxVfdwuvt76PbDuTn2RocZLVG@mail.gmail.com>
 <1278038796.19705.21.camel@clockmaker-el6>
 <Pine.LNX.4.64.1007020456250.9535@bwv190.internetdsl.tpnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007020456250.9535@bwv190.internetdsl.tpnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >There is no point supporting companies that give you a little bit of
> >information in exchange they want the support that being in a mainline
> >kernel gives. Its an unfair exchange of knowledge and time, and if they
> >claim they have to make a profit then its even more unfair.
> 
> also, they seem to do it quite wrong way. i.e. much simpler would be
> to just implement regular, open driver , and implement additional
> crypto
> mechanism in chipset itself, allowing to use simple userspace program
> sending certified keys allowing GPU to operate.

What is going on there? Does msm actually use crypto to prevent you
from use hardware you bought?

Are the keys device-specific? What prevents me from
reverse-engineering their binary and publishing them?	
						                     Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
