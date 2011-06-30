Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1F3Ssc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:48:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55321 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1F3Ssb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:48:31 -0400
MIME-Version: 1.0
In-Reply-To: <4E0CBFF0.2040205@zytor.com>
References: <20110622063441.GA1740@x4.trippels.de> <4E048C0D.7020403@suse.cz>
 <20110624135100.GB1708@x4.trippels.de> <201106241833.15424.arnd@arndb.de>
 <BANLkTi=9e-it8nd2s-vcbEfc1h8tnSmj8A@mail.gmail.com> <4E0CBFF0.2040205@zytor.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 30 Jun 2011 14:48:11 -0400
X-Google-Sender-Auth: Xm0CAECu2Xi7q1hB-ZG1OvBcSoA
Message-ID: <BANLkTikKq64RPyT3CS8U+zdc2HmqHYZt4Q@mail.gmail.com>
Subject: Re: {PATCH] fix __packed in exported kernel headers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Michal Marek <mmarek@suse.cz>, Joe Perches <joe@perches.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 14:26, H. Peter Anvin wrote:
> On 06/24/2011 10:00 AM, Mike Frysinger wrote:
>>> We generally try to add no such requirements on user applications.
>>
>> the only real solution there is to export the compiler.h headers too
>>
>> plus, many compilers nowadays (like icc/llvm) tend to include support
>> for common gcc attributes ...
>
> Either that OR define a set of macros as being expected by the
> environment of the kernel ABI headers (to be provided by the library.)

without fallback logic (#ifndef xxx...#define xxx...#endif), i think
that's throwing an unreasonable amount of requirements onto userspace
consumers
-mike
