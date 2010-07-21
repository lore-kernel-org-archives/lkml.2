Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0GURR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:17:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33352 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0GURRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iOs+ss1h51FIZSX/sZoNEWoJUwdiu+oUO8SvbAF11/WTjXQgS+eRI0qqci0gWZs9bd
         vzpLU70KewxCoI1BxWS88KS/nJkImHIcYpUQ0EHihV/LZX3tmZkxr1WLkvWZ56K/A/l2
         eOP7S9+nGlLJgKrDQ/joDGGhw4RkBrpTIaOvk=
Date: Wed, 21 Jul 2010 21:17:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100721171718.GF8009@lenovo>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com> <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com> <20100720200729.GD6227@lenovo> <20100720201740.GE6227@lenovo> <4C472123.1090900@zytor.com> <20100721165211.GD8009@lenovo> <20100721170124.GE8009@lenovo> <4C472A5C.50004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C472A5C.50004@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 10:11:56AM -0700, H. Peter Anvin wrote:
> On 07/21/2010 10:01 AM, Cyrill Gorcunov wrote:
> > 
> > Peter, also I think such tuning must be done at merge window time only,
> > just to not break other's patch queues.
> > 
> 
> Realistically it should be done right after the merge window for the
> *next* merge window.
> 
> 	-hpa
>

ok, which means Robert should use old conventional test at the moment
instead of introducing is_boot_cpu I suppose.

	-- Cyrill
