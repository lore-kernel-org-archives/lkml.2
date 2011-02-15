Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab1BOQt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:49:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40856 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab1BOQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:49:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=muu28cjxHfVuVh038zUw7VcLbWkZY3QUmqfDKQUcvAOqJqjnF6ouq1TPIYaVdafCNr
         uzZQyObeznwYlEgH0cWbYVMg4jagWGEcqkMuMrb4blf3v9t11zbn/3T0NMPYtOabd5jN
         CJ8II5KkaCpxfSyH+PpM3M3HIY/OHdjYVVfY8=
Date: Tue, 15 Feb 2011 17:49:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk
 registration
Message-ID: <20110215164920.GR3160@htj.dyndns.org>
References: <20110214161249.GV18742@htj.dyndns.org>
 <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
 <20110214162247.GX18742@htj.dyndns.org>
 <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
 <20110214182718.GB18742@htj.dyndns.org>
 <4D597D56.5060408@kernel.org>
 <20110214193050.GC18742@htj.dyndns.org>
 <4D5983EA.4020103@kernel.org>
 <20110215091103.GC3160@htj.dyndns.org>
 <20110215094327.GA1387@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215094327.GA1387@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 10:43:27AM +0100, Ingo Molnar wrote:
> Would be nice to have a version against the latest tip:x86/numa
> tree, the current one conflicts in arch/x86/mm/numa_64.c with your
> tree. Also, i suspect you want to propagate Yinghai's Acked-by's
> into the commits?

Acked-by added and rebased on top of the current x86/numa.  Only one
patch needed to be updated and the udpated version was just posted.
The updated git branches are available at

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-unify
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify

The latter one is superset of the former.

If you want the whole series reposted, please let me know.

Thanks.

-- 
tejun
