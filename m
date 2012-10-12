Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2JLU6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:58:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2JLU6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:58:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
Date: Fri, 12 Oct 2012 20:58 +0000
Message-ID: <2456603.OlK4shzgJ4@wuerfel>
User-Agent: KMail/4.9 beta2 (Linux/3.5.0-7-generic; KDE/4.8.90; x86_64; ; )
In-Reply-To: <1349865374.6072.78.camel@shinybook.infradead.org>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com> <alpine.LFD.2.00.1210091020390.11244@dhcp-1-104.brq.redhat.com> <1349865374.6072.78.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:B2Tvl4Tw+3WhQtaDMP8146AdptMwssMXjdSaryNnvye
 HzIu2Yyu7GaqAdciBLJSPA9nxuLf3zvlTfowqDGyo7L3r+EF+O
 ttomiIUDTwaER8AtZ/FdTce2wOMO07NdevBS44uOg5JxB4metq
 2w8RXXdgqAvC+iU+6Eu8SJbU97Y0+FhzG6IXpkiSYndstXWSZa
 Fb8rM8D+PibzMZphIN+rt+jSlM4j5b8rnUUvCMbt7vNX9NOF6J
 kwsV+6l0O65t5jQADtlTthExkBkARkY2WRmCqY+OFEj4PcNp4B
 qe88sZYgm4n1R3N4g5z4yxVvEEylaO+VOg0nNKxlA0/lVMGBzK
 wdZykxIbDX0KV9eeiswg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2012 11:36:14 David Woodhouse wrote:
> The whole thing is silly. What we actually want on an embedded system is
> to ditch the FTL altogether and have direct access to the NAND. Then we
> can know our file system is behaving optimally. And we don't need
> hacks like TRIM to try to make things a little less broken.

I think it's safe to say that the times for raw flash in consumer devices
are over, whether we like it or not. Even if we could go back to MTD
for internal storage, we'd still need something better than what we
have for removable flash storage such as USB and SD.

(and I know that xD cards are basically raw flash, but have you tried
to buy one recently?)

	Arnd
