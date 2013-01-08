Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3AHEL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 23:11:29 -0500
Received: from nm25.access.bullet.mail.mud.yahoo.com ([66.94.237.90]:47354
	"EHLO nm25.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab3AHEL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 23:11:28 -0500
X-Yahoo-Newman-Id: 447219.16477.bm@smtp108.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jv6rESsVM1k8LByBK7Rpu0gH75cQZqVtsbMdArjtOv8Csvr
 8Z8vr.OgD24uvqSVKmtwqoFIZCnQzZF07tMnHSNiAkQ0to3TZqAWtI81D7BQ
 Y7ivb97u3TGrmOPvwuhoM3tMIDPOlIh_eJyIUqW9UUhcIg_koy0gjWElEgcs
 NQW7yRsA1lTudYg8c2kv3zjD1D.h7S4SHAGewDuuuAv0GAzkbVw.owVcxQvw
 x4Kvu1wEgY483GTOCmjsgmDrkI9e3zDo05JgNZFySWz1UV537VtdygZHPQIj
 eopPsoZLP4ssO325wnvxFONYiB9hpnQS62aLTd1RyDKK8vZpyV_IqHzpGW0H
 9xQYgRjrbJIM7GOKQmNJsBrd3EEieapnzh1EdJJ2m19SJkkEzriCKAOntOFw
 lmhk1LRVRJhDzRua4BUoPRCiUgzm1Ly30mypGOcsst7FBS23XcxeK5TzvnSB
 wMhjU
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EB9C7E.7090304@schaufler-ca.com>
Date: Mon, 07 Jan 2013 20:11:42 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au> <20130108145922.58ab8ad4796076c9d14b6197@canb.auug.org.au>
In-Reply-To: <20130108145922.58ab8ad4796076c9d14b6197@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/2013 7:59 PM, Stephen Rothwell wrote:
> Hi Casey,
>
> On Tue, 8 Jan 2013 14:01:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Let me ask Andrew's question:  Why do you want to do this (what is the
>> use case)?  What does this gain us?
>>
>> Also, you should use unique subjects for each of the patches in the
>> series.
> You probably also want to think a bit harder about the order of the
> patches - you should introduce new APIs before you use them and remove
> calls to functions before you remove the functions.
>
The unfortunate reality is that I couldn't find a good way to stage the
changes. It's a wonking big set of infrastructure change. I could introduce
the security blob abstraction separately but that is a fraction of the
change. If it would have gone through mail filters as a single patch I'd
have sent it that way.

I can spend time on patch presentation, and will if necessary. As it is,
I can start getting substantive commentary from beyond the LSM crowd, who
have already been extremely cooperative and often critical.

