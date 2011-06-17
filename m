Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1FQR2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:28:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48092 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1FQR2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CsHh9OJIqpHkAUKSQ+s7HiQEyFPYlumBmCfvyWAeJIGI/nWukMXEBYj3c6PhFEhc4Q
         vv84qzN2syPSTGEEGJH170xULAa7CiapuBHuaMHYPeicVQ9T2nglysOQGa1RdCSVNPv/
         lCMGyOqi6qrNuS8ixalTWro0ZWnOA0W/mAIR8=
MIME-Version: 1.0
In-Reply-To: <4DFB8AAF.1040002@fb.com>
References: <20110615163115.773d072e.akpm@linux-foundation.org>
 <1308187784-3815-1-git-send-email-asharma@fb.com> <BANLkTi=f2N+dO2nBLobM73jCg0U0QSqxNQ@mail.gmail.com>
 <4DFB8AAF.1040002@fb.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 17 Jun 2011 13:28:25 -0400
Message-ID: <BANLkTindmEA7NsaRjuukh1-oRCtVWpeuCA@mail.gmail.com>
Subject: Re: [PATCH] atomic: cleanup asm-generic atomic*.h inclusion
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 13:11, Arun Sharma wrote:
> On 6/16/11 11:36 PM, Mike Frysinger wrote:
>> i'm not sure this doesnt break things.  what tree exactly should i
>> apply this patch to to verify things ?
>
> I tested 3.0-rc2 + patch 1 + patch 2 + this patch.

not sure what those patches are, so i picked at random:
Subject: [PATCH 2/3] atomic: move atomic_add_unless to generic code
Date: Tue,  7 Jun 2011 17:07:18 -0700
Message-Id: <1307491639-9864-2-git-send-email-asharma@fb.com>

Subject: [PATCH 1/3] atomic: use <linux/atomic.h>
Date:	Mon,  6 Jun 2011 10:27:29 -0700
Message-Id: <1307381251-15729-1-git-send-email-asharma@fb.com>

but even after just these two, things fail because
include/asm-generic/atomic.h provides atomic_add_unless() already.
i'm guessing your patch 2/3 should have fixed that somehow since it
adds the func to linux/atomic.h.
-mike
