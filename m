Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2JCLks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:40:48 -0400
Received: from nm34-vm5.bullet.mail.bf1.yahoo.com ([72.30.239.77]:27712 "HELO
	nm34-vm5.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752038Ab2JCLkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:40:46 -0400
X-Yahoo-Newman-Id: 285333.64702.bm@omp1026.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8b2unv4VM1mYXDi1__wbkVgkb_rywHS1n9NAt7YnoXB8bQH
 ouWv9HjOBjWcVQO4quIU7N4g1vlWsxQxPNlbJGKMgvKeQ5Z467q_wd91VEL.
 rnx_BdQ.5cDEE3aI6vObvNfVcVOZYFaGnbt7x0lroWauqAHqlrjldHyVUtz0
 upIU_FR4PIgDFXMabaE0u5GjZUCnaelvPhLyfbldbk174WSoZs0jjl5NlHHE
 g9YsEvmHS5wj6ejf2QDMsEf.JLyLgiSOM.jYCUkPfbPuFCfaW9PKEa4rTVeW
 3DKao8Rr3r1cjR9v1Tst6RIg5XR4LZo26ieYsMC2DSIPy3KjMrY7GODXBpxG
 e.8fuA6JeIAmR4W65yYIW9qmDcj4wG_BImTPgh3j2afVy2.h7UEC6tK3_dd.
 DkF0ZnC1CMVvC7q6HwZgg6Uo0sUosx9SEDFyxqqHlFuvUAy0itg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506C2636.6020304@att.net>
Date: Wed, 03 Oct 2012 06:49:10 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6/10] bug.h: Replace __linktime_error with __compiletime_error
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-7-git-send-email-daniel.santos@pobox.com> <alpine.DEB.2.00.1210022344180.12717@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210022344180.12717@chino.kir.corp.google.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 01:44 AM, David Rientjes wrote:
> On Fri, 28 Sep 2012, Daniel Santos wrote:
>
>> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> After this is folded into the previous patch in the series, 
> "compiler{,-gcc4}.h: Remove duplicate macros", then:
>
> 	Acked-by: David Rientjes <rientjes@google.com>
Thanks.  I've actually just reversed the patch order per Josh's
suggestion and added patch comments to it.  I can squash them if you
guys prefer.

Unfortunately, I'm a bit confused as to how I should re-submit these,
still being new to this project.  Patch 1 is already in -mm. Patches 2-3
have not changed. I've made a correction to patch #4 and reversed the
order of 5 & 6. And what was 8-10 is now 8-15, as I've completely
re-done BUILD_BUG_ON.  I was planning on just submitting the whole set
again, is this the correct protocol?  If so, should I reply to the
original [PATCH 0/10] thread or create a new one?

Thanks!
Daniel
