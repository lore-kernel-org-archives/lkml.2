Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab2I2Aej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:34:39 -0400
Received: from nm16-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.210]:47589 "HELO
	nm16-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759225Ab2I2Aei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:34:38 -0400
X-Yahoo-Newman-Id: 707962.10058.bm@omp1014.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aEx0SBwVM1ke9pmz0bUABEdw89n26sbw7mf7bDWgph51Y_J
 jau4qbxc4qiPItFG3CHCGuKhxrEUv3LOHMHGVGdy4yOhRFlKsO9LTSiO4hOP
 k8W4QBYzyrOkjy0N6OxUZoDi__6sRn7jKxqigtDEwyKXyRh_MJMFXigqYB_f
 dUrKpO.tb7UCTK3QgwPLfGrSxIA6iY9p8m_EuS1d2UaAvHO3.S8rUxvgHoOK
 bVeTzCXNjoLuZT7_xTMOs8JQgdBk2kub626gpOzMFD.FM9Egz8GCzAElEN6p
 ys9pBMzTMAXP7DAexkuP8WZNyE_f7Wh1WNnXf181hx1NG9QleFCr8.SWmBnF
 C1Cj6QKFlzVn.8JF_bAIxHCakHv4hv3YEtPrtgcW8FhkfppZpfi1_QijdWcE
 xrXJUULAt37qk5G3cRbZ.Ef5rOm0GEYfkyZLdjZP411GuzNpT5g--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5066421C.20904@att.net>
Date: Fri, 28 Sep 2012 19:34:36 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
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
Subject: Re: [Bulk] Re: [PATCH 5/10] compiler{,-gcc4}.h: Remove duplicate
 macros
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-6-git-send-email-daniel.santos@pobox.com> <20120929002329.GB13907@jtriplet-mobl1>
In-Reply-To: <20120929002329.GB13907@jtriplet-mobl1>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 07:23 PM, Josh Triplett wrote:
> On Fri, Sep 28, 2012 at 06:20:06PM -0500, Daniel Santos wrote:
>> __linktime_error() does the same thing as __compiletime_error() and is
>> only used in bug.h.  Since the macro defines a function attribute that
>> will cause a failure at compile-time (not link-time), it makes more
>> sense to keep __compiletime_error(), which is also neatly mated with
>> __compiletime_warning().
>>
>> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> Why not change bug.h in the same commit?  Or alternatively, why not
> change it first?
I'm still new to this project's development process and wasn't sure if
those two changes would be considered lumping multiple changes together
or not.  So that type of lumping is acceptable then?  I certainly
wouldn't mind squashing them.
> Getting rid of __linktime_error *before* changing its
> use in bug.h to __compiletime_error seems wrong.
Good point!

