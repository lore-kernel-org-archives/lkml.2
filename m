Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1BPRd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:33:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63320 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab1BPRd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:33:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E/oGmV8RhPcH8OY4mTRwWkgIWLKywi50a1dj7kE5/+8tWlC/uDWNaCLGSjClaSFCKQ
         nzjA89lK0Y+XfoP7WnfXgsu5duvmceL4jCPYckvKYe+lremQU5qnD5Ia2tCQIulIMnqq
         N3ysMR2qGfaZg9w2KrFKIrZB6wtasL3m4JoS4=
Date: Wed, 16 Feb 2011 18:33:45 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA
 config/emulation
Message-ID: <20110216173345.GL19830@htj.dyndns.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
 <20110216125249.GA18113@elte.hu>
 <20110216141757.GG19830@htj.dyndns.org>
 <20110216155314.GA22855@elte.hu>
 <20110216162329.GI19830@htj.dyndns.org>
 <20110216172954.GA28054@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216172954.GA28054@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 16, 2011 at 06:29:54PM +0100, Ingo Molnar wrote:
> > Okay, updated again.  I'm trying to build all combinations of the
> > several affected configurations now.  I'll let you know how it turns
> > out.
> 
> It's looking good here now.

Yeah, I'm still iterating through different combinations but I haven't
seen any failure yet.  Maybe it actually was the last failure. :-) I'm
gonna test ~10 more combinations.  I'll write if something fails.

Thanks.

-- 
tejun
