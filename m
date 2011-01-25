Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1AYNcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:32:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46877 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1AYNcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:32:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AYDp2e6+yf+gqkpMW7Kz6/9oyBoiPPzNuJefudQAPcmxX33MpXasGDLRpPITjUOETk
         cKRkUpcNzc5778Vzywebun5ZlQVm6i6Tf3bmLYYxfXX7cW3lWlF4G+HAAjjo5MtnzdnN
         RlExAAHqW5rW4WUiO5z+De4Km7eNYBNY2x798=
Date: Tue, 25 Jan 2011 14:32:13 +0100
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH RESEND percpu#for-next] percpu: align percpu readmostly
 subsection to cacheline
Message-ID: <20110125133213.GV27510@htj.dyndns.org>
References: <20101227133719.GD488@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101227133719.GD488@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 02:37:19PM +0100, Tejun Heo wrote:
> Currently percpu readmostly subsection may share cachelines with other
> percpu subsections which may result in unnecessary cacheline bounce
> and performance degradation.
> 
> This patch adds @cacheline parameter to PERCPU() and PERCPU_VADDR()
> linker macros, makes each arch linker scripts specify its cacheline
> size and use it to align percpu subsections.
> 
> This is based on Shaohua's x86 only patch.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Shaohua Li <shaohua.li@intel.com>
> ---
> Shaohua, can you please verify this achieves the same result?  If no
> one objects, I'll route it through the percpu tree.

Applied to percpu#for-2.6.39.

Thanks.

-- 
tejun
