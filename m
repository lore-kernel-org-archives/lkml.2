Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117Ab1IINqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:46:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36699 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1IINqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:46:07 -0400
Subject: Re: [PATCH 1/2] kvm tools: fix repeated io emulation
From: Sasha Levin <levinsasha928@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
In-Reply-To: <4E69794F.9010008@cn.fujitsu.com>
References: <4E4C81CE.8030508@cn.fujitsu.com>
	 <CAOJsxLEtQR3ue-suoC3akhGB=DwyoSofD_RuuNmz=A2jede22g@mail.gmail.com>
	 <1313652951.28910.4.camel@lappy> <4E4D2AEC.8050601@redhat.com>
	 <4E69794F.9010008@cn.fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 09 Sep 2011 16:45:41 +0300
Message-ID: <1315575941.22919.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 10:26 +0800, Xiao Guangrong wrote:
> On 08/18/2011 11:08 PM, Avi Kivity wrote:
> > On 08/18/2011 12:35 AM, Sasha Levin wrote:
> >> On Thu, 2011-08-18 at 09:13 +0300, Pekka Enberg wrote:
> >> >  Hi,
> >> >
> >> >  On Thu, Aug 18, 2011 at 6:06 AM, Xiao Guangrong
> >> >  <xiaoguangrong@cn.fujitsu.com>  wrote:
> >> >  >  When kvm emulates repeation io read instruction, it can exit to user-space with
> >> >  >  'count'>  1, we need to emulate io access for many times
> >> >  >
> >> >  >  Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> >> >
> >> >  The KVM tool is not actually maintained by Avi and Marcelo but by me
> >> >  and few others. Our git repository is here:
> >> >
> >> >  https://github.com/penberg/linux-kvm
> >> >
> >> >  Ingo pulls that to -tip few times a week or so. Sasha, can you please
> >> >  take a look at these patches and if you're OK with them, I'll apply
> >> >  them.
> >>
> >> Pekka,
> >>
> >> I can only assume they're right, 'count' isn't documented anywhere :)
> >>
> >> If any of KVM maintainers could confirm it I'll add it into the docs.
> >>
> > 
> > Count is indeed the number of repetitions.
> > 
> 
> Hi Pekka,
> 
> Could you pick up this patchset please?
> 

Xiao, It was merged couple of weeks ago.

-- 

Sasha.

