Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab1C3PWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:22:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54756 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab1C3PWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KijuhDtkuKgYMxWMm2dfDr44q7JDHyq948WjaQzCBmbpw26hDqYYUr6kvF3Z9R+dot
         A+MynJ/vrf8U7b9YE9V+6ubUSn5EUdpexi36d+y2kmmZIqIoYBZ5nfC2VASj6VHdQMLD
         Nj4XkYyoe1lzpSWDq5jHS7SgHstCMxMVCYpaA=
Date: Wed, 30 Mar 2011 17:19:48 +0200
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH tip:x86/mm 3/3] acpi throttling: Use this_cpu_has and
 simplify code current cpu
Message-ID: <20110330151948.GI17523@htj.dyndns.org>
References: <20110312115010.GC2005@htj.dyndns.org>
 <20110312115046.GD2005@htj.dyndns.org>
 <20110312115112.GE2005@htj.dyndns.org>
 <20110328164039.GF6736@htj.dyndns.org>
 <alpine.DEB.2.00.1103300918240.25965@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103300918240.25965@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 09:20:08AM -0500, Christoph Lameter wrote:
> > Ingo, are you planning on picking these up?
> 
> Guess the patches missed the merge period. There could be more
> optimizations of arch code if the infrastructure for this_cpu_has() would
> be in but I guess I better hold off for awhile.

Yeah, merging didn't go very smooth with your recent patches.  Sorry
about that.  I applied the this_cpu_has() patches to x86-mm and will
soon send pull request to Ingo.  Please feel free to send further
patches on top of that tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git

Thanks.

-- 
tejun
