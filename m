Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab2EAOlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 10:41:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2EAOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 10:41:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Date: Tue, 1 May 2012 14:40:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Mike Frysinger <vapier@gentoo.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <201204271926.14872.vapier@gentoo.org> <20120501133429.GB23919@mudshark.cambridge.arm.com>
In-Reply-To: <20120501133429.GB23919@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205011440.57639.arnd@arndb.de>
X-Provags-ID: V02:K0:7wSn1tfFHWCdOrgdZC8L7sfAeSyAEw4eJUeJ+Gnmb+J
 UYzeViCt0V3K7rkipwYi2g6T8gJ1ZAZNVRM0IiUVMCPUQWbbxs
 qdC3ye/dmKRABFY8U5OjJgfhBmpP+sK2FS/ZIdaWZ8gCjN51x0
 zsPAy9qNHvErIX4cQFcqCrThG7CE0aXcrXOkK/Hw+4uGMxj/8M
 YSuSf97cpA3UNIJ6oVd/Q1QA01mX0UoABGRyULXSGaHSPxpXOX
 73A8rnMCcoAZMPLbHRDVYB4SrLfzBeNmHgJC1wsSNtZF7rqqPS
 HNF+G1mEW+86np0VF8SfY0Kdl1YkLYbzqolwjGo/1xj1tTMCq0
 OCAtRZweHqo93dxGq8Uw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2012, Will Deacon wrote:
> It would be nice if we could just use asm-generic/io.h as the documention,
> i.e. if you want to write a portable driver, just stick to the functions
> implemented there. Apart from the string accessors, I think it's already
> fairly accurate. The __raw_* functions seem to be missing on s390 but I
> don't think driver portability is a huge concern for that architecture.

Actually, s390 has none of the mmio accessors right now, because there
is no PCI or other memory mapped hardware.

	Arnd
