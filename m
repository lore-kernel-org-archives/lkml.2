Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2FYIff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:35:35 -0400
Received: from nm10.access.bullet.mail.sp2.yahoo.com ([98.139.44.137]:27979
	"HELO nm10.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751318Ab2FYIfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:35:32 -0400
X-Yahoo-Newman-Id: 239855.642.bm@omp1007.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fhw3ixEVM1neLvDMZfRtsprgnFXDh43zPoESiUj_8L1QNE3
 ot_M2UyrqIWGS7lxuNTqP1ieaNr6A.phjuffM._bRSvS2PZSTueLMPV7Hk3Q
 dPpr664beVBsFfYiwfIVjtUqpVN2Y9GLutpWDKbwi0TnL3UdZgWPh59v880n
 UdGNsiVqOdxPZwa4ScD9ra4roy0DAIq2vvRSzAviM7_9JVGkZXZLzec4D7F_
 BT8HbSF.P.4HscWEDFoeugv6kTrKKedLEyAxi_QELh473ntdfLMeoIHYli93
 XqAkSgtjPYetXCESWFLWz61hUZim43iAk.F.XTAloQ3XRn53YrnBMuHWT9wF
 4H4Ghyw0P9GyckxKtQIxuaBo33gssFbFBCBVMbWrWrK59aF99RZdktRkoGpF
 vdjBqQg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FE822D2.7000407@att.net>
Date: Mon, 25 Jun 2012 03:35:30 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
CC: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v4 0/13] Generic Red-Black Trees
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com> <4FE661F8.3000109@att.net> <4FE69A14.6040904@landley.net> <201206240957.09136.pisa@cmp.felk.cvut.cz>
In-Reply-To: <201206240957.09136.pisa@cmp.felk.cvut.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It would worth to have even user space version of the
> kernel RB tree code with Dainie's interface to run feasibility
> and performance tests in more environments quickly
> (as Daniel mentioned already). But it is not necessary
> for me to be convinced that provided changes should go into
> kernel because I am convinced  already and offer my
> "Reviewed-by" confirmation.
Thanks Pavel!

As far as user-space testing, I have a simple test program that
compilers in user-space using a hacked-up system include directory and
compiles the kernel code unmodified.  I'll be sure and write the test
code to work both in-kernel and in user space, although working out the
portability of the build will be a bit of a challenge.

Daniel

