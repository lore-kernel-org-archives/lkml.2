Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1F3V4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:56:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50662 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1F3V4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:56:43 -0400
MIME-Version: 1.0
In-Reply-To: <4E0CD64D.406@zytor.com>
References: <20110622063441.GA1740@x4.trippels.de> <4E048C0D.7020403@suse.cz>
 <20110624135100.GB1708@x4.trippels.de> <201106241833.15424.arnd@arndb.de>
 <BANLkTi=9e-it8nd2s-vcbEfc1h8tnSmj8A@mail.gmail.com> <4E0CBFF0.2040205@zytor.com>
 <BANLkTikKq64RPyT3CS8U+zdc2HmqHYZt4Q@mail.gmail.com> <4E0CC5F4.7010002@zytor.com>
 <BANLkTimf=21wbscEZRtfm+XFue713w7ZNA@mail.gmail.com> <4E0CC824.40909@zytor.com>
 <BANLkTi=dGPz4MpSKUNWaA_W1t4C_+zV=0w@mail.gmail.com> <4E0CD64D.406@zytor.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 30 Jun 2011 17:56:22 -0400
X-Google-Sender-Auth: xB1SjwumaWhOzCBbiFjdkksHncE
Message-ID: <BANLkTimO0=V24FXYx4CEHTa6tLNB-0F-dQ@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 16:02, H. Peter Anvin wrote:
> On 06/30/2011 12:13 PM, Mike Frysinger wrote:
>>> Not unless the kernel uses its own namespace for these defines.  The
>>> thing is, most libraries have their own macro library for this, and
>>> collisions are both likely and bad.
>>
>> while that's true for exporting compiler.h, namespacing is irrelevant
>> to my requirement -- the headers should have sane/usable defaults.
>
> I have no idea what "your requirements" are

it's what ive already said and what you commented on multiple times.
exporting a header that cant be included directly without first
declaring some random set of defines is broken.

i'm not referring to some arbitrary set of requirements you may not know.

> but as someone who has
> actually implemented a C library on top of the Linux headers I can tell
> you it's a very real and relevant issue, and that it is historically one
> of the biggest problems.

no one said otherwise.  ive done quite a lot of work with uClibc, so
i'm familiar with the historical issues as well.
-mike
