Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3ADWBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:01:45 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:42744 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3ADWBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:01:43 -0500
MIME-Version: 1.0
In-Reply-To: <1357319947.7763.1.camel@jsakkine-mobl1>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-7-git-send-email-yinghai@kernel.org>
	<1357319947.7763.1.camel@jsakkine-mobl1>
Date: Fri, 4 Jan 2013 14:01:42 -0800
X-Google-Sender-Auth: tg1_6sFardI7vCt0g_-IRAOMSbw
Message-ID: <CAE9FiQU4ZZJkHbVy-RFkY_P10RyQ6LREYz7B=w4hR=u3J+iQbg@mail.gmail.com>
Subject: Re: [PATCH v7u1 06/31] x86, 64bit, realmode: use init_level4_pgt to
 set trapmoline_pgt directly
From: Yinghai Lu <yinghai@kernel.org>
To: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 9:18 AM, Sakkinen, Jarkko
<jarkko.sakkinen@intel.com> wrote:
> On Thu, 2013-01-03 at 16:48 -0800, Yinghai Lu wrote:
>> with #PF handler way to set early page table, level3_ident will go away with
>> 64bit native path.
>>
>> So just use entries in init_level4_pgt to set them in tramopline_pgt
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
>
> Acked-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

Thanks.

updated the patch, and would save some time for HPA.
