Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0ENQPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:15:30 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:44470 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab0ENQP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:15:28 -0400
Date: Fri, 14 May 2010 11:12:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
In-Reply-To: <4BECDD5D.9010609@gmail.com>
Message-ID: <alpine.DEB.2.00.1005141110100.9466@router.home>
References: <4BEC7A84.3010503@gmail.com> <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>  <AANLkTim7fnKebMoEu1DjD3S-15ZqlTUez3Lpp0wGVJQ6@mail.gmail.com> <AANLkTimmctk1GWOTlW8Han7E3gJVgqJjUAMeqYnvyuHn@mail.gmail.com>
 <4BECDD5D.9010609@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Justin P. Mattock wrote:

> I enable these options as well..
> (then see If I can(hopefully)re-create this
> then I'll bisect it).

Debugging causes a slowdown. You can switch debuggin on for a specific
slab.

f.e.

slub_debug=,kmalloc-8192

See also Documentation/vm/slub.txt

