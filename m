Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab2J0FLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 01:11:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34891 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2J0FLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 01:11:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkRjk7r2sRtSPXo4HY1U6T_XtUXRrc7fz3fwqW7NYkrs1Q=QA@mail.gmail.com>
References: <20121024160253.GB6567@Super-MAGI>
	<CAHkRjk7r2sRtSPXo4HY1U6T_XtUXRrc7fz3fwqW7NYkrs1Q=QA@mail.gmail.com>
Date: Sat, 27 Oct 2012 13:11:09 +0800
Message-ID: <CA+HMz3iZr--ccT7PyvkK7k3u=pGiAgYL2kHA4X-FW0_vENLuGQ@mail.gmail.com>
Subject: Re: [PATCH]Documentation:Chinese translation of Documentation/arm64/memory.txt
From: Ninja Tekkaman <tekkamanninja@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Harry Wei <harryxiyou@gmail.com>,
        Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel@vger.linux-kernel.cn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Catalin
I have a question about the original document.
what is the exact meaning about the "memory" in
"ffffffc000000000	ffffffffffffffff	 256GB		memory"
Can I treat it as "kernel logical address space" ? Or maybe It can be
modified to “kernel” ？

It's relevant to my Chinese translation.

--
Tekkaman Ninja
2012/10/25 Catalin Marinas <catalin.marinas@arm.com>:
> 2012/10/24 Tekkaman Ninja <tekkamanninja@gmail.com>:
>> This is a Chinese translated version of
>> Documentation/arm64/memory.txt
>>
>> Signed-off-by: Fu Wei <tekkamanninja@gmail.com>
>
> As long as you maintain it and you keep it in sync:
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>
> I used google translate and it seems close to the original document :)
>
> --
> Catalin
