Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab2JDAzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:55:04 -0400
Received: from nm3-vm0.bullet.mail.sp2.yahoo.com ([98.139.90.230]:42317 "HELO
	nm3-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964832Ab2JDAzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:55:00 -0400
X-Yahoo-Newman-Id: 413049.3935.bm@omp1006.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OFDJjJ4VM1nLSaDya5gRop_OyuN4l.LsNWXm7gS3wIKG5ty
 cU1WcBaeWewQgIS6YY68S5O1VRncTcxITJV3lf_TpIRjEUYQpgj_8GnuNDOg
 u23keb7at2weUgxw2GsPU0sdu0SqvdvIIbbj60z29mDHyhELpDaCcreEjAb1
 3b.YipstPOR04gn3ZkSU51bF7b_oBWEKj6XFS_Ye6K.H5j_v96qsViMkaL0F
 roDLmYGKx8ybsU5lRZHeJGmBmK2i9TQ7WNxW48zJmiy6s_hlIoh3AqgGpBle
 OwgC3mALJq.V1s5chGRd3aA6xtmgfsySoVo03bX3HMLGgL_NixFGlkI.Ycm6
 UDwj1LGf3Ppexa1E_0AhSRsZF4CxHDNJzIJJImf4Dd5CteMtrxxt0jSniwmI
 EdXRBJ3NQcMpvw9BMVBuBUjYwiMlvzdepx0QVTv_a8320NKzneg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506CDE62.5030907@att.net>
Date: Wed, 03 Oct 2012 19:54:58 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Joe Perches <joe@perches.com>, Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-8-git-send-email-daniel.santos@pobox.com> <20120929002626.GD13907@jtriplet-mobl1> <50664308.6020601@att.net> <20120929005043.GD14293@jtriplet-mobl1> <alpine.DEB.2.00.1210022347500.12717@chino.kir.corp.google.com> <20121003065959.GA4963@leaf> <alpine.DEB.2.00.1210030052040.16922@chino.kir.corp.google.com> <506C1F8B.1070307@att.net> <1349272914.22822.169.camel@gandalf.local.home> <506C4FD0.4040307@att.net> <1349277241.22822.176.camel@gandalf.local.home> <1349278697.2112.1.camel@joe-AO722> <1349310757.6755.7.camel@gandalf.local.home>
In-Reply-To: <1349310757.6755.7.camel@gandalf.local.home>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 07:32 PM, Steven Rostedt wrote:
> On Wed, 2012-10-03 at 08:38 -0700, Joe Perches wrote:
>> On Wed, 2012-10-03 at 11:14 -0400, Steven Rostedt wrote:
>>> I first check
>>> the MAINTAINERS file. If the subsystem I'm working on exists there, I
>>> only email those that are listed there, including any mailing lists that
>>> are mentioned (as well as LKML). If it's not listed, I then do a git log
>>> and see who does the most sign offs to changes there, and to what kind
>>> of changes. I usually ignore the trivial stuff.
>>
>> Funny because that's what the script does too.
>>
>
> Really? It ignores the trivial stuff and only adds people that seem to
> actually do real work on the file?
>
> If that's the case, I doubt that it would have caused the huge Cc list
> that Daniel sent out.
>
> -- Steve
Well, you run that on:
* include/linux/bug.h,
* include/linux/compiler{,-gcc{,3,4}}.h,
* include/linux/rbtree.h,
* tools/testing/selftests,
* Documentation/DocBook/kernel-api.tmpl and
* scripts/kernel-doc,
and it really starts to add up (that's currently 23 on mmotm, not including
myself). Now, add people already involved in the patch set, etc., and it
makes
its way to 30.  That's why I split the patch set up.

Daniel
