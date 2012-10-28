Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2J1Cjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 22:39:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44243 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab2J1Cji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 22:39:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkRjk6_sf6dtdcwV=-TbwA33V=tuEXdVnjcz6p00UYSdDV=rA@mail.gmail.com>
References: <20121024160253.GB6567@Super-MAGI>
	<CAHkRjk7r2sRtSPXo4HY1U6T_XtUXRrc7fz3fwqW7NYkrs1Q=QA@mail.gmail.com>
	<CA+HMz3iZr--ccT7PyvkK7k3u=pGiAgYL2kHA4X-FW0_vENLuGQ@mail.gmail.com>
	<CAHkRjk6_sf6dtdcwV=-TbwA33V=tuEXdVnjcz6p00UYSdDV=rA@mail.gmail.com>
Date: Sun, 28 Oct 2012 10:39:37 +0800
Message-ID: <CA+HMz3h5GR6Tch82nGsSOHY7246NRpGNtbxaHNqbafPPV+VHpw@mail.gmail.com>
Subject: Re: [PATCH]Documentation:Chinese translation of Documentation/arm64/memory.txt
From: Ninja Tekkaman <tekkamanninja@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Harry Wei <harryxiyou@gmail.com>,
        Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your answer!
So I will make a patch for it (in English and Chinese).
For English patch ,if you like it, please acked it.

2012/10/27 Catalin Marinas <catalin.marinas@arm.com>:
> On 27 October 2012 06:11, Ninja Tekkaman <tekkamanninja@gmail.com> wrote:
>> I have a question about the original document.
>> what is the exact meaning about the "memory" in
>> "ffffffc000000000       ffffffffffffffff         256GB          memory"
>> Can I treat it as "kernel logical address space" ? Or maybe It can be
>> modified to “kernel” ？
>
> It's the linear mapping of the RAM used by the kernel. So you could
> say "kernel logical memory map" (I wouldn't say address space as this
> is wider and it includes vmalloc, modules etc.)
>
> --
> Catalin
