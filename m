Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2JCOqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:46:44 -0400
Received: from nm20-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.21]:30312 "HELO
	nm20-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754671Ab2JCOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:46:43 -0400
X-Yahoo-Newman-Id: 227293.7560.bm@omp1001.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3dvgAA4VM1l6S6yBCavqf_jbefxvUcNndncX9ib.6I3oOL.
 mSO_.amF._VlNHA2aLAzLESY9hgwrEikH70R2TYBFtKeXAf4gmSqiGKQYHie
 _79xbbDlLpW7N67vu_UhiL7zFxh_GVKHMf4K3l9Juqdj1eH3Rwrc3ow6HXvT
 lJ13DEdQHw95LxKVd9pEYg0FORZVSuuNcZVloot.O3T36Tod0Nw_a2IOw33j
 i9LAWubNMXhcq6MnaKnqjjqOnarRpVfgDWipm59ExD2ctpLClh7GyRTKsAub
 UfcuLpRrlAxn7FYTSQYV.4wHChHR7R8x93.24GzC3FZbxYou05xZDRJvQPso
 tYUfqFNvP2dnz3ypP2Lm9tO3twSonBYqt4EMGs0JS.azaOXSDJfGgqmVv_GE
 ByXmRwvjK1d_ItwbuNIw0Jy.AHnPy740BN.uB4EMiNI3D_kM10akZ9rePn7x
 aKo.Grey8daLpSTCZBvXN6rHhk1Q8DhFF4SeRX9FSodfcKy83oWipzt3z_0i
 dIPKJCVtPELjK74nxQVG0vkkNbr.A7MTyrT1CQtzutITTesaU_ZDXGmutIJj
 lM.6E.w--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506C4FD0.4040307@att.net>
Date: Wed, 03 Oct 2012 09:46:40 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Josh Triplett <josh@joshtriplett.org>,
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
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-8-git-send-email-daniel.santos@pobox.com> <20120929002626.GD13907@jtriplet-mobl1> <50664308.6020601@att.net> <20120929005043.GD14293@jtriplet-mobl1> <alpine.DEB.2.00.1210022347500.12717@chino.kir.corp.google.com> <20121003065959.GA4963@leaf> <alpine.DEB.2.00.1210030052040.16922@chino.kir.corp.google.com> <506C1F8B.1070307@att.net> <1349272914.22822.169.camel@gandalf.local.home>
In-Reply-To: <1349272914.22822.169.camel@gandalf.local.home>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 09:01 AM, Steven Rostedt wrote:
> On Wed, 2012-10-03 at 06:20 -0500, Daniel Santos wrote:
>
>>> Daniel, please introduce __flatten in the patch series that uses it, 
>>> thanks.
>> That isn't going to work. I split my patches out into three sets
>> because, otherwise, the list of maintainers that must be CCed exceeds
>> the allowable size of the LKML server and my messages get tagged as
>> spam, causing untold confusion as messages reach maintainers, but not
>> the LKML.  Please note from the summary of this patch set
>> (https://lkml.org/lkml/2012/9/28/1136)
> That's not a valid reason to not included it with the other patch
> series.
>
>>> This patch set is a dependency of the generic red-black tree patch set, which
>>> I have now split up into three smaller sets.
>> And the patch set this depends upon was submitted 9/28 as well
>> (https://lkml.org/lkml/2012/9/28/1183) and the summary starts with this
>> text:
>>> This patch set depends upon the following:
>>> * Cleanup & new features for compiler*.h and bug.h
>>> * kernel-doc bug fixes (for generating docs)
>> If I move this patch to the other patch set,
>> scripts/get_maintainers.pl will give me a list longer than the LKML
>> administrator will allow for recipients (1024 bytes max)
> You don't need to use get_maintainers. It's more of a help tool to find
> maintainers and not something that is mandatory. Not everyone that has
> ever touched one of these files needs to be Cc'd.
>
> Please move the patch to the patch series where it is used. Otherwise it
> confuses reviewers as it did here.
Ok then, but this would also apply to the addition of these macros as well:
BUILD_BUG_ON_NON_CONST
BUILD_BUG42
BUILD_BUG_ON_NON_CONST42

Should these then also be moved?
Should I only CC those who have responded to these patches and whomever
is in the MAINTAINERS file then?

Thanks
Daniel

