Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2HMXoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 19:44:17 -0400
Received: from mail.servus.at ([193.170.194.20]:43719 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab2HMXoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 19:44:16 -0400
Message-ID: <50299142.2030504@oberhumer.com>
Date: Tue, 14 Aug 2012 01:44:02 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.6esrpre) Gecko/20120713 Thunderbird/10.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <andi@firstfloor.org>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: [GIT PULL] Update LZO compression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

as suggested on the mailing list I have converted the updated LZO
code into git, so please pull my "lzo-update" branch from

  git://github.com/markus-oberhumer/linux.git lzo-update

You can browse the branch at

  https://github.com/markus-oberhumer/linux/compare/lzo-update

I'd ask some official kernel maintainer for review and to push this into
linux-next so that it will hopefully land in the 3.7 release.

Share and enjoy,
Markus

Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>

On 2012-07-16 20:30, Markus F.X.J. Oberhumer wrote:
> Hi all,
>
> I finally have prepared a small package that updates the LZO version
> in the Linux kernel. Please get it from:
>
> http://www.oberhumer.com/opensource/lzo/download/Testing/linux-kernel-lzo-20120716.tar.gz
>
> As stated in the README this version is significantly faster (typically more
> than 2 times faster!) than the current version, has been thoroughly tested on
> x86_64/i386/powerpc platforms and is intended to get included into the
> official Linux 3.6 or 3.7 release.
>
> I encourage all compression users to test and benchmark this new version,
> and I also would ask some official LZO maintainer to convert the updated
> source files into a GIT commit and possibly push it to Linus or linux-next.
>
> Share and enjoy,
> Markus
>
> Signed-off-by: Markus F.X.J. Oberhumer" <markus@oberhumer.com>

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
