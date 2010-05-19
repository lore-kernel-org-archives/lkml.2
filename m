Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab0ESNid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:38:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56500 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0ESNic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:38:32 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric.dumazet@gmail.com, Ingo Molnar <mingo@elte.hu>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
Subject: Re: Does anyone care about gcc 3.x support for *x86* anymore?
From: Andi Kleen <andi@firstfloor.org>
References: <4BF33CAD.2070602@zytor.com>
Date: Wed, 19 May 2010 15:38:26 +0200
In-Reply-To: <4BF33CAD.2070602@zytor.com> (H. Peter Anvin's message of "Tue\, 18 May 2010 18\:19\:41 -0700")
Message-ID: <871vd8xb8t.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> If there isn't a reason to preserve support, I would like to consider
> discontinue support for using gcc 3 to compile x86 kernels.  If there is
> a valid use case, it would be good to know what it is.

I suspect there are still distributions around that use it as a standard
compiler. Wasn't it used in some major release of Debian?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
