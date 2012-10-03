Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab2JCPSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:18:17 -0400
Received: from nm38-vm5.bullet.mail.ne1.yahoo.com ([98.138.229.149]:34613 "HELO
	nm38-vm5.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754243Ab2JCPSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:18:11 -0400
X-Yahoo-Newman-Id: 127375.75941.bm@omp1022.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ruS6fU0VM1leCeODemj24B..3jwzGh.KPbzSaSz.QCZ.oZw
 _fkF4v_BerQsYuodMMvld7dpmv5kmnCMFxPKmCNvwn_7_eCFUc4KCHQLF.MS
 k1VN0A.era0l.IO2PEHMlc0y26AsGJM6OEGfh6vg_z3sCat0StnG5IWoP6gv
 bMPWEycC6uFydXpaxcBRQZFcbZPnOWfwshbOCcK2mgIkGbCS2SDXU1Y6lNQ4
 vq1.jOmIFUKs6FVdN_Tgu8skjOdalsnnHJNj8TxiAbdXaOP9K_9VjLRGhpgx
 e7gHpUv7uFyOCdaBtk_OyZNQ3Qn3uk63tJzgy1Zeza99w3TKeK.zJMZIX0pX
 JzFqDkT3KAVaBhaBTQYjLf.wFNsrabWAll7AKK3eWEcbNpVl75LUyfLbDYbM
 Rwi9C7iDea5GQ5XAe3i52RPgZ2RZvSnmfv_FQvfQQQyjCxf8maEfbr_F_upv
 yJYDdbipmWd542NCmGqUfnahR0T5e_D9hLC.Fl3fGG9D2rC3SVsaxkXy5UK.
 CcgJDC6spFL1EO92ut1qe37ol
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506C572E.8020403@att.net>
Date: Wed, 03 Oct 2012 10:18:06 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Borislav Petkov <bp@alien8.de>, Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v6 0/25] Generic Red-Black Trees
References: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com> <20121001124331.540a2615.akpm@linux-foundation.org> <5069FFEA.20900@att.net> <20121001134739.689ecfe6.akpm@linux-foundation.org>
In-Reply-To: <20121001134739.689ecfe6.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 03:47 PM, Andrew Morton wrote:
> On Mon, 01 Oct 2012 15:41:14 -0500
> Daniel Santos <danielfsantos@att.net> wrote:
>
>> I can rebase against whatever you like and send either corrections or an
>> updated patch set. Just tell me what works please.
> I dropped everything - let's start again.
I would have sent you my updated patch set, but both -mmotm and -next
are broken on my hardware at the moment and I can't properly re-test.  I
posted a bug here: https://bugzilla.kernel.org/show_bug.cgi?id=48241
(with early boot jpg).  I can rebase it against Linus maybe for testing
(just a few changes).

I did use gcc 4.7.1, so I'm going to try using gcc 4.6.3 just to make
sure it's not that.  But it looks like I may have a few more changes to
make anyway.

Daniel
