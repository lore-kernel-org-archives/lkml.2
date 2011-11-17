Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1KQSUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:20:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59758 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab1KQSUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:20:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKaqa+c6dvCPyiXO81EVb67faz7+ht9xHcZpPpke2eStw@mail.gmail.com>
References: <20111116211329.GA8328@www.outflux.net>
	<4EC4D248.5070704@linux.intel.com>
	<CAGXu5jKaqa+c6dvCPyiXO81EVb67faz7+ht9xHcZpPpke2eStw@mail.gmail.com>
Date: Thu, 17 Nov 2011 10:20:14 -0800
Message-ID: <CA+8MBb+gOeDRnTy9PN-Tt22a3WybnSiJ8tdKSKtT3C0pt=51Uw@mail.gmail.com>
Subject: Re: [PATCH v2] pstore: pass allocated memory region back to caller
From: Tony Luck <tony.luck@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Chen Gong <gong.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Would you please tell me how do you construct such a scenario to
>> get above call trace?
>
> Yeah, I just mounted pstore. :)

I found that setting CONFIG_DEBUG_ATOMIC_SLEEP=y to be
helpful in reproducing this.

-Tony
