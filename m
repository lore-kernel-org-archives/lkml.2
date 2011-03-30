Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1C3QID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:08:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45135 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1C3QIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:08:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Il9vj2jQa3YyESCo/RCj9ii2OReZ/CdtWVDAR7PzsqV8sFbQWjRAmoXSpmb9nVA32R
         +VSRtj1aI9VB21wRTYcg/+QH3w3BL+DtCJP/RpEaL6BZH1NsFImPgMygMvWfMy2GrzEL
         5B6v8O2jUOMxjPccQoNU/t1bEXHnCCDaR6KjA=
Date: Wed, 30 Mar 2011 18:07:56 +0200
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH tip:x86/mm 1/3] x86: A fast way to check capabilities
 of the current cpu
Message-ID: <20110330160756.GL17523@htj.dyndns.org>
References: <20110312115010.GC2005@htj.dyndns.org>
 <m2k4g1zdmt.fsf@firstfloor.org>
 <4D93531F.5080403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D93531F.5080403@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 30, 2011 at 08:58:23AM -0700, H. Peter Anvin wrote:
> >> Add this_cpu_has() which determines if the current cpu has a certain
> >> ability using a segment prefix and a bit test operation.
> > 
> > 
> > Hmm: if the CPU capability is really tested in a performance critical
> > path, wouldn't it even be better to just use static_branch() now? 
> > 
> 
> We have static_cpu_has() for this specific purpose (it actually predates
> static_branch()).

These patches have performance benefits but I don't think it would be
noticeable.  I think it's more of code cleanup.

Thanks.

-- 
tejun
