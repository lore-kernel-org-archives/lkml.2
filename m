Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1F3S4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:56:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59751 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab1F3S4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:56:09 -0400
Message-ID: <4E0CC5F4.7010002@zytor.com>
Date: Thu, 30 Jun 2011 11:52:36 -0700
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
References: <20110622063441.GA1740@x4.trippels.de> <4E048C0D.7020403@suse.cz> <20110624135100.GB1708@x4.trippels.de> <201106241833.15424.arnd@arndb.de> <BANLkTi=9e-it8nd2s-vcbEfc1h8tnSmj8A@mail.gmail.com> <4E0CBFF0.2040205@zytor.com> <BANLkTikKq64RPyT3CS8U+zdc2HmqHYZt4Q@mail.gmail.com>
In-Reply-To: <BANLkTikKq64RPyT3CS8U+zdc2HmqHYZt4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 11:48 AM, Mike Frysinger wrote:
> without fallback logic (#ifndef xxx...#define xxx...#endif), i think
> that's throwing an unreasonable amount of requirements onto userspace
> consumers

Unclear.  Too much "smarts" in kernel headers is a constant headache to
userspace consumers.

	-hpa

