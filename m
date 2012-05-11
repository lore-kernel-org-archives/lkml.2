Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2EKASQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:18:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:56607 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab2EKASP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:18:15 -0400
Message-ID: <1336695464.3881.71.camel@pasglop>
Subject: Re: [PATCH v2 1/4] fork: move the real prepare_to_copy() users to
 arch_dup_task_struct()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        oleg@redhat.com, linux-kernel@vger.kernel.org,
        suresh@aristanetworks.com, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
        Chris Zankel <chris@zankel.net>
Date: Fri, 11 May 2012 10:17:44 +1000
In-Reply-To: <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
References: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com>
	 <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 16:33 -0700, Suresh Siddha wrote:
> Historical prepare_to_copy() is mostly a no-op, duplicated for majority of
> the architectures and the rest following the x86 model of flushing the extended
> register state like fpu there.
> 
> Remove it and use the arch_dup_task_struct() instead.
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>

For the powerpc part:

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.



