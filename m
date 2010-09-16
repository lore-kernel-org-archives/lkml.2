Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab0IPHrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:47:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39744 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0IPHrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Z1thxjXxJogduoF4DOFPNmS8acwTf77+KO3V4yl59VVQRMk5EcQPdEqPWFTmj8JMr1
         bNTUg+1kcOJ7Upu96cyy993SGoeGPizeCpV71c8qIS2HTXPpGmGqplOcR6UI1RJHXeUU
         cMbKssupr5tpKsqOCYh1uH1QMwnWhVCKHKD6s=
MIME-Version: 1.0
In-Reply-To: <20100916155413.3BC0.A69D9226@jp.fujitsu.com>
References: <20100916145452.3BB1.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1009152300380.25200@chino.kir.corp.google.com>
	<20100916155413.3BC0.A69D9226@jp.fujitsu.com>
Date: Thu, 16 Sep 2010 10:47:05 +0300
X-Google-Sender-Auth: BSGBl_4W_xwq7-dKWG2mDpkSdX0
Message-ID: <AANLkTikyxAZBp63FxY26_MS6afDZO59r2FNoWF9W-GmT@mail.gmail.com>
Subject: Re: [PATCH 1/4] oom: remove totalpage normalization from oom_badness()
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        Brad Spengler <spender@grsecurity.net>, Eugene Teo <eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 9:57 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Thu, 16 Sep 2010, KOSAKI Motohiro wrote:
>>
>> > Current oom_score_adj is completely broken because It is strongly bound
>> > google usecase and ignore other all.
>> >
>>
>> We've talked about this issue three times already.  The last two times
>> you've sent a revert patch, you failed to followup on the threads:
>>
>>       http://marc.info/?t=128272938200002
>>       http://marc.info/?t=128324705200002
>>
>> And now you've gone above Andrew, who is the maintainer of this code, and
>> straight to Linus.  Between that and your failure to respond to my answers
>> to your questions, I'm really stunned at how unprofessional you've handled
>> this.
>
> Selfish must die. you failed to persuade to me. and I havgen't get anyone's objection.
> Then, I don't care your ugly whining.

I haven't followed the discussion at all so I hope you don't mind me
jumping in. Are there some real-world bug reports where OOM rewrite is
to blame? Why haven't those been fixed?

                        Pekka
