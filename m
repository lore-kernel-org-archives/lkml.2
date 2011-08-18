Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab1HRHhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:37:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44402 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1HRHhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:37:04 -0400
Subject: Re: [PATCH 1/2] kvm tools: fix repeated io emulation
From: Sasha Levin <levinsasha928@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
In-Reply-To: <CAOJsxLEtQR3ue-suoC3akhGB=DwyoSofD_RuuNmz=A2jede22g@mail.gmail.com>
References: <4E4C81CE.8030508@cn.fujitsu.com>
	 <CAOJsxLEtQR3ue-suoC3akhGB=DwyoSofD_RuuNmz=A2jede22g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 18 Aug 2011 10:35:51 +0300
Message-ID: <1313652951.28910.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 09:13 +0300, Pekka Enberg wrote:
> Hi,
> 
> On Thu, Aug 18, 2011 at 6:06 AM, Xiao Guangrong
> <xiaoguangrong@cn.fujitsu.com> wrote:
> > When kvm emulates repeation io read instruction, it can exit to user-space with
> > 'count' > 1, we need to emulate io access for many times
> >
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> The KVM tool is not actually maintained by Avi and Marcelo but by me
> and few others. Our git repository is here:
> 
> https://github.com/penberg/linux-kvm
> 
> Ingo pulls that to -tip few times a week or so. Sasha, can you please
> take a look at these patches and if you're OK with them, I'll apply
> them.

Pekka,

I can only assume they're right, 'count' isn't documented anywhere :)

If any of KVM maintainers could confirm it I'll add it into the docs.

-- 

Sasha.

