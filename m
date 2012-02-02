Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2BBIgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 03:36:54 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:59739 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab2BBIgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 03:36:52 -0500
Message-ID: <4F2A4B22.7020909@msgid.tls.msk.ru>
Date: Thu, 02 Feb 2012 12:36:50 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110805 Icedove/5.0
MIME-Version: 1.0
To: Professor Berkley Shands <berkley@seas.wustl.edu>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.0.18 tcsetattr on fd 0 when detached freezes system (RCU timeouts)
 (Centos 6.1 x86_64)
References: <4F234498.5070800@seas.wustl.edu> <4F239BE1.4090106@msgid.tls.msk.ru> <4F283B40.1070200@seas.wustl.edu>
In-Reply-To: <4F283B40.1070200@seas.wustl.edu>
X-Enigmail-Version: 1.2.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.01.2012 23:04, Professor Berkley Shands wrote:
> Very strange. Now boxes with NO OFED, no Intel-10 Gige and no special drivers are locking up.
> If your kernel is Red Hat compatible, could you please send me a copy of the .config so I can try to
> isolate this more?

Why are you writing to me personally?  I just
tried your code and can't find the problem you
see, and I replied to the list.  Cc'ing to the
list now.

I don't understand what is "redhat compatible".
I use kernel from kernel.org, currently at version
3.0.18.

Did you try my small "reproducer" - does it lock your
machines too?  I provided complete code which is
compilable and runnable, unlike your version which
lacked some context.

Thanks,

/mjt
