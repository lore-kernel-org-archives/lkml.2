Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1HRGNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:13:37 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:47038 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1HRGNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:13:35 -0400
MIME-Version: 1.0
In-Reply-To: <4E4C81CE.8030508@cn.fujitsu.com>
References: <4E4C81CE.8030508@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 09:13:34 +0300
X-Google-Sender-Auth: _VyG1q_ieUKTRepz3th6eJdQ99M
Message-ID: <CAOJsxLEtQR3ue-suoC3akhGB=DwyoSofD_RuuNmz=A2jede22g@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm tools: fix repeated io emulation
From: Pekka Enberg <penberg@kernel.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 18, 2011 at 6:06 AM, Xiao Guangrong
<xiaoguangrong@cn.fujitsu.com> wrote:
> When kvm emulates repeation io read instruction, it can exit to user-space with
> 'count' > 1, we need to emulate io access for many times
>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

The KVM tool is not actually maintained by Avi and Marcelo but by me
and few others. Our git repository is here:

https://github.com/penberg/linux-kvm

Ingo pulls that to -tip few times a week or so. Sasha, can you please
take a look at these patches and if you're OK with them, I'll apply
them.

                        Pekka
