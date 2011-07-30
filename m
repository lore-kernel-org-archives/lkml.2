Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1G3WYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:24:19 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65043 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1G3WYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <1312064244.22074.21.camel@i7.infradead.org>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530104231.GF17821@elte.hu>
	<20110530104656.GA19532@elte.hu>
	<E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	<20110530105809.GA20133@elte.hu>
	<1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	<alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	<20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	<alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	<1306795186.2029.459.camel@i7.infradead.org>
	<BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>
	<1306856937.27477.3.camel@i7.infradead.org>
	<BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
	<4E0495F4.7080300@suse.cz>
	<1311986969.20983.52.camel@i7.infradead.org>
	<CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com>
	<alpine.LFD.2.02.1107301716430.21839@localhost6.localdomain6>
	<CACqU3MVY89L3B3=eFrmsgD2wzXtbQHssPm4D_-VZGEWNYBR4-Q@mail.gmail.com>
	<4E34548F.9040909@zytor.com>
	<4E347FC4.60600@zytor.com>
	<1312064244.22074.21.camel@i7.infradead.org>
Date: Sat, 30 Jul 2011 18:24:13 -0400
Message-ID: <CACqU3MUfpSeHBOPjkAcpdGSugoC3w4hyCs_igUxppohPj+o=2A@mail.gmail.com>
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid overriding CONFIG_64BIT
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 30, 2011 at 6:17 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sat, 2011-07-30 at 15:03 -0700, H. Peter Anvin wrote:
>> It isn't meaningless for exactly that reason.  For example,
>> "make ARCH=x86 USERARCH=i386" and "make ARCH=x86 USERARCH=x86_64" both
>> make sense.  Similarly, "make ARCH=um USERARCH=i386" is different from
>> "make ARCH=um USERARCH=x86_64".
>
> In that case it's redundant with CONFIG_64BIT, isn't it?
>
How do you plan to handle x32, if it ever makes it to mainline ?

 - Arnaud
