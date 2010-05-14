Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0ENOaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:30:04 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:41569 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab0ENOaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:30:00 -0400
Date: Fri, 14 May 2010 09:26:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
In-Reply-To: <AANLkTimmctk1GWOTlW8Han7E3gJVgqJjUAMeqYnvyuHn@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1005140926180.7867@router.home>
References: <4BEC7A84.3010503@gmail.com> <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>  <AANLkTim7fnKebMoEu1DjD3S-15ZqlTUez3Lpp0wGVJQ6@mail.gmail.com> <AANLkTimmctk1GWOTlW8Han7E3gJVgqJjUAMeqYnvyuHn@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Luis R. Rodriguez wrote:

> > CONFIG_SLUB_DEBUG and then either CONFIG_SLUB_DEBUG_ON or pass
> > 'slub_debug' as kernel parameter.
>
> Ah OK I had CONFIG_SLUB_DEBUG but not  CONFIG_SLUB_DEBUG_ON, will
> enable it from here on.

The slub_debug kernel parameter is there so that you can avoid having to
set CONFIG_SLUB_DEBUG_ON.


