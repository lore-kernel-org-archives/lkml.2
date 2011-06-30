Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1F3UEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 16:04:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60463 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab1F3UEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 16:04:14 -0400
Message-ID: <4E0CD64D.406@zytor.com>
Date: Thu, 30 Jun 2011 13:02:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Michal Marek <mmarek@suse.cz>, Joe Perches <joe@perches.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: {PATCH] fix __packed in exported kernel headers
References: <20110622063441.GA1740@x4.trippels.de> <4E048C0D.7020403@suse.cz> <20110624135100.GB1708@x4.trippels.de> <201106241833.15424.arnd@arndb.de> <BANLkTi=9e-it8nd2s-vcbEfc1h8tnSmj8A@mail.gmail.com> <4E0CBFF0.2040205@zytor.com> <BANLkTikKq64RPyT3CS8U+zdc2HmqHYZt4Q@mail.gmail.com> <4E0CC5F4.7010002@zytor.com> <BANLkTimf=21wbscEZRtfm+XFue713w7ZNA@mail.gmail.com> <4E0CC824.40909@zytor.com> <BANLkTi=dGPz4MpSKUNWaA_W1t4C_+zV=0w@mail.gmail.com>
In-Reply-To: <BANLkTi=dGPz4MpSKUNWaA_W1t4C_+zV=0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 12:13 PM, Mike Frysinger wrote:
>>
>> Not unless the kernel uses its own namespace for these defines.  The
>> thing is, most libraries have their own macro library for this, and
>> collisions are both likely and bad.
> 
> while that's true for exporting compiler.h, namespacing is irrelevant
> to my requirement -- the headers should have sane/usable defaults.
> 

I have no idea what "your requirements" are, but as someone who has
actually implemented a C library on top of the Linux headers I can tell
you it's a very real and relevant issue, and that it is historically one
of the biggest problems.

	-hpa
