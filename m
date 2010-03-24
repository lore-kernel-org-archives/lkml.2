Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0CXNe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:34:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:45890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0CXNe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:34:28 -0400
Message-ID: <4BAA14AB.5010906@kernel.org>
Date: Wed, 24 Mar 2010 22:33:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Lee.Schermerhorn@hp.com, cl@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, yi.zhu@intel.com,
       reinette.chatre@intel.com, ilw@linux.intel.com,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/4] include cleanup: Update gfp.h and slab.h includes
 to 	prepare for breaking implicit slab.h inclusion from percpu.h
References: <1269420538-18039-1-git-send-email-tj@kernel.org>	 <1269420538-18039-4-git-send-email-tj@kernel.org>	 <84144f021003240400y43484fe6q8be4e8dc22284e9b@mail.gmail.com> <b6fcc0a1003240457x5aff83deo3aeac26f6bcf037@mail.gmail.com>
In-Reply-To: <b6fcc0a1003240457x5aff83deo3aeac26f6bcf037@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Mar 2010 13:33:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 08:57 PM, Alexey Dobriyan wrote:
> On Wed, Mar 24, 2010 at 1:00 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> How do we get this merged before we grow more implicit dependencies?
> 
> Send it to Linus and cross fingers. ;-)

I'll wait a couple of days and if nobody objects, I'll push it to
linux-next so that it can get wider testing and then if nothing breaks
too horribly, I'll ask Linus with a pretty please.  :-)

Oh, BTW, the patch description on 0003 has a lot of broken sentences.
I was too tired to proof read it, sorry.  I'll fix it up before
pushing it out.

Thanks.

-- 
tejun
