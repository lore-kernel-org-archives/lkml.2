Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2JCLMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:12:19 -0400
Received: from nm20.bullet.mail.ac4.yahoo.com ([98.139.52.217]:38868 "HELO
	nm20.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750773Ab2JCLMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:12:18 -0400
X-Yahoo-Newman-Id: 201863.19767.bm@omp1011.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: A634HbgVM1kp8xJEyHvl2J2TGoyHpu3MUczw6DlbXlVHX0U
 IXRW08y4l3SFI5Zwhv_I02sgMCs6ssnjsXbHZr.tDlSwWO7jBFR6t9Fw.UQo
 6QvMvqaiEf7bLsq.Ud0tvIgPv3rptPFckPIWRcJyJS6bwuShxhsEXoyYQZdA
 9Jk2oxoKqRrnADXw6SRqx1TZGSVZJS_vKHuydh1D_Mgg4CbnifNVQrzgA.Li
 jvoMjExxen4aQgWjioqnmzsTFYJvXWsUAgmCqYZDvVatbngdLOPbcOxwx1wa
 Eusv6fEUChaAxABpUHDLL_s4U98drLrJRYWAw6pAYinCIsGiDz6NsvT9WglY
 rHu4HazasMaI31MdYJGsTumYja9xwNyvEUGs90lSC3lXbLtny7S5qzWH1uy0
 XjssifTlzptT59k.95808EODGGwKHkXto2D9.Czh9NRzKmaUlL6niGw3lbbt
 r35Octm.NtgAUy6mtqUEMeJ6dshD1CYLv38R1e43rfByQTeXIbjDXzdPTDyu
 C5R4nsJMtiPGV0wPmZEPm9TI._pOEZuR4rCdwTgcjpVxIYucwfYxc7SDSFWG
 FgBqc.Q--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506C1F8B.1070307@att.net>
Date: Wed, 03 Oct 2012 06:20:43 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Josh Triplett <josh@joshtriplett.org>,
        Daniel Santos <daniel.santos@pobox.com>,
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
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-8-git-send-email-daniel.santos@pobox.com> <20120929002626.GD13907@jtriplet-mobl1> <50664308.6020601@att.net> <20120929005043.GD14293@jtriplet-mobl1> <alpine.DEB.2.00.1210022347500.12717@chino.kir.corp.google.com> <20121003065959.GA4963@leaf> <alpine.DEB.2.00.1210030052040.16922@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210030052040.16922@chino.kir.corp.google.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 02:53 AM, David Rientjes wrote:
> On Tue, 2 Oct 2012, Josh Triplett wrote:
>
>> This patch series started out as part of another patch series by Daniel
>> Santos that makes use of __flatten; I think Daniel plans to have that
>> patch series depend on this one.  Thus, I think it makes sense to
>> introduce __flatten at this point.
>>
>
> Daniel, please introduce __flatten in the patch series that uses it, 
> thanks.
That isn't going to work. I split my patches out into three sets
because, otherwise, the list of maintainers that must be CCed exceeds
the allowable size of the LKML server and my messages get tagged as
spam, causing untold confusion as messages reach maintainers, but not
the LKML.  Please note from the summary of this patch set
(https://lkml.org/lkml/2012/9/28/1136)
> This patch set is a dependency of the generic red-black tree patch set, which
> I have now split up into three smaller sets.
And the patch set this depends upon was submitted 9/28 as well
(https://lkml.org/lkml/2012/9/28/1183) and the summary starts with this
text:
> This patch set depends upon the following:
> * Cleanup & new features for compiler*.h and bug.h
> * kernel-doc bug fixes (for generating docs)
If I move this patch to the other patch set, scripts/get_maintainers.pl will give me a list longer than the LKML administrator will allow for recipients (1024 bytes max)


On 09/28/2012 12:46 PM, David Miller wrote:
> From: Daniel Santos <danielfsantos@att.net>
> Date: Fri, 28 Sep 2012 09:22:52 -0500
>
>> Hello. I'm trying to send a patch set and people in my TO list are
>> receiving the emails, but not the LKML.
> You can't have email fields larger than 1024 characters, that CC:
> list is way too large.  There is never any legitimate reason to
> CC: so many people, and we block such long email fields since
> %99.99999 they indicate spam.
If you have any other reasonable suggestions, please post them.

Thanks,
Daniel
