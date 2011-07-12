Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1GLSto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:49:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39782 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1GLStn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:49:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAFziu1EYYN6imDijo7E_raOfdXfWAMzfJL5OursSBAYk8Wdywg@mail.gmail.com>
References: <CACqU3MW=VUn64nsSA2V_eXEfEjv6xmB9yBWL8rYynH1wkHcOgw@mail.gmail.com>
	<1310454020-15426-1-git-send-email-abogani@kernel.org>
	<CAFziu1HvspbMj8LRLHd2w9vcVq_mGCL3pCOwLaduKQ4nt8+Utg@mail.gmail.com>
	<CACqU3MVZ6UPZKSsSSjZosTYfbzuwj_dCumK-wcb_SWhs+8OgNQ@mail.gmail.com>
	<CAFziu1EYYN6imDijo7E_raOfdXfWAMzfJL5OursSBAYk8Wdywg@mail.gmail.com>
Date: Tue, 12 Jul 2011 14:49:42 -0400
Message-ID: <CACqU3MUXAOMGQ1nzUrtYPEQAC3U-nuq3YurtNJJLS1hft4ROGA@mail.gmail.com>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V2
From: Arnaud Lacombe <lacombar@gmail.com>
To: Anders Kaseorg <andersk@ksplice.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 12, 2011 at 2:35 PM, Anders Kaseorg <andersk@ksplice.com> wrote:
> On Tue, Jul 12, 2011 at 14:15, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> modpost is an host tool, it should not include kernel header. Content
>> of this file is not exported to userland anyway.
>
> My point was more that you might as well reuse the same name and
> probably the same code so that people don’t have to look carefully at
> a new macro to decide whether it’s off-by-one from what they expect.
>
Agree. I was not entirely sure of what you meant, ie. whether
including "include/linux/string.h" or adjusting the name and
definition to match the existing. So I thought it would just be better
to clear any potential misunderstanding :)

 - Arnaud
