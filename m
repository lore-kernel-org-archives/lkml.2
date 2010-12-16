Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab0LPQOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:14:55 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:48460 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0LPQOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:14:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Jl/gEVrm/Y/u32/pjczpI3O9x+lkMmom/EfgAkYvHsvD4vzNNHTCAaiMW+XuhgpjPy
         LKewK+1QNSdRDrh0AB4c0SfThM7K3OKZJbUGbGzeJ9TEFwRymCxGsh7CwkYOZ84aLdfK
         UGa7gNGfPY4j8JPuOh1zHnCeHeIex62ub/7C4=
Message-ID: <4D0A3AF2.50508@gmail.com>
Date: Thu, 16 Dec 2010 17:14:42 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org>
In-Reply-To: <4D08EF4E.8070403@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On 12/15/2010 05:39 PM, Tejun Heo wrote:
> I'd prefer percpu things going through percpu tree, if for nothing
> else for git history's sake, but I don't think it really matters.  The
> series is spread all over the place anyway.  As long as each
> maintainer is properly alerted about the changes, it should be okay.
> Please let me know whether you agree with the changes currently queued
> in percpu#for-next.  I'll update the tree with your Acked-by's and
> freeze it.

Are you okay with the patches currently in percpu#for-next?  If so,
I'll regenerate patches with your acked-by and pop the two previously
mentioned commits and proceed with the rest of the series.

Thank you.

-- 
tejun
