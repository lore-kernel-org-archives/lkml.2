Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab2J0Pqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:46:36 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43178 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab2J0Pqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+HMz3iZr--ccT7PyvkK7k3u=pGiAgYL2kHA4X-FW0_vENLuGQ@mail.gmail.com>
References: <20121024160253.GB6567@Super-MAGI> <CAHkRjk7r2sRtSPXo4HY1U6T_XtUXRrc7fz3fwqW7NYkrs1Q=QA@mail.gmail.com>
 <CA+HMz3iZr--ccT7PyvkK7k3u=pGiAgYL2kHA4X-FW0_vENLuGQ@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Sat, 27 Oct 2012 16:46:13 +0100
X-Google-Sender-Auth: YiJn-a_mxK7D_CpB16qQ_sR8DrY
Message-ID: <CAHkRjk6_sf6dtdcwV=-TbwA33V=tuEXdVnjcz6p00UYSdDV=rA@mail.gmail.com>
Subject: Re: [PATCH]Documentation:Chinese translation of Documentation/arm64/memory.txt
To: Ninja Tekkaman <tekkamanninja@gmail.com>
Cc: Harry Wei <harryxiyou@gmail.com>,
        Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel@vger.linux-kernel.cn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 October 2012 06:11, Ninja Tekkaman <tekkamanninja@gmail.com> wrote:
> I have a question about the original document.
> what is the exact meaning about the "memory" in
> "ffffffc000000000       ffffffffffffffff         256GB          memory"
> Can I treat it as "kernel logical address space" ? Or maybe It can be
> modified to “kernel” ？

It's the linear mapping of the RAM used by the kernel. So you could
say "kernel logical memory map" (I wouldn't say address space as this
is wider and it includes vmalloc, modules etc.)

-- 
Catalin
