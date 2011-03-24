Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958Ab1CXTlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:41:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54141 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab1CXTlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HTO//ZhPufu1zW6z1S/mDrb26dJzxggPoxKSGkCnlX7Mc7vf8+4XI4Zr4KQw2Parxw
         +jvz6RI5IVxN0LZNcHsb4xyaG9RVlIe3eIkghSBbZ0sakZZ/eqhLT2d9hdRC0DQpKEMM
         Jp5fgkA3q579RJA6l2rJmKaesEenWSs2AGoCU=
MIME-Version: 1.0
In-Reply-To: <20110324193647.GA7957@elte.hu>
References: <alpine.DEB.2.00.1103241300420.32226@router.home>
	<AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
	<alpine.DEB.2.00.1103241312280.32226@router.home>
	<1300990853.3747.189.camel@edumazet-laptop>
	<alpine.DEB.2.00.1103241346060.32226@router.home>
	<AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
	<20110324185903.GA30510@elte.hu>
	<AANLkTi=66Q-8=AV3Y0K28jZbT3ddCHy9azWedoCC4Nrn@mail.gmail.com>
	<alpine.DEB.2.00.1103241404490.5576@router.home>
	<AANLkTimWYCHEsZjswLpD-xDcu_cL=GqsMshKRtkHt5Vn@mail.gmail.com>
	<20110324193647.GA7957@elte.hu>
Date: Thu, 24 Mar 2011 21:41:51 +0200
X-Google-Sender-Auth: OpMlJ-n2abnXN4lgVvkqGPiitmg
Message-ID: <AANLkTinBwKT3s=1En5Urs56gmt_zCNgPXnQzzy52Tgdo@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 9:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Pekka Enberg <penberg@kernel.org> wrote:
>
>> > -#if defined(CONFIG_CMPXCHG_LOCAL) && defined(CONFIG_PREEMPT)
>> > +#ifdef CONFIG_CMPXCHG_LOCAL
>> >        int cpu;
>> >
>> >        for_each_possible_cpu(cpu)
>> >
>>
>> Ingo, can you try this patch out, please? I'm compiling here but
>> unfortunately I'm stuck with a really slow laptop...
>
> Yes, it does the trick with the config i sent.
>
> Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks, Ingo! Christoph, may I have your sign-off for the patch and
I'll send it to Linus?
