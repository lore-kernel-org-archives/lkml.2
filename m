Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1AIAgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 19:36:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1AIAgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 19:36:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCHv1 02/12] unicore32 core architecture: generic headers stuff
Date: Sun, 9 Jan 2011 01:36:35 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <00c801cba463$b0f3db00$12db9100$@mprc.pku.edu.cn> <201101070055.53996.arnd@arndb.de> <023a01cbaf1b$3022b5b0$90682110$@mprc.pku.edu.cn>
In-Reply-To: <023a01cbaf1b$3022b5b0$90682110$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101090136.35793.arnd@arndb.de>
X-Provags-ID: V02:K0:FyavpNq1GzvjFfHI9UG/33mvbnuo+5pL6L7Sjbzd765
 x5qaYcxtJ/5DR4e4Yqz1C2AgQqQbyJQJkZO6nCE6xL++X8D3ji
 r2ButK0DH3asSFFkixpuD+TzB3lB+nFO6Dm41xNgHkJAQlEQlG
 UxrKitYqTc8gg4RM958PDcAaEcOHde1FtKD5Cdkg0mAmiLp/o1
 shhn+OeMwjCgb4crNt1Bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 January 2011, Guan Xuetao wrote:
> > I think we discussed this particular header before. There should be no reason
> > to have your own version instead of using the generic file like you do for the
> > rest of the API headers.
>
> The generic-version stat.h can't work for existing binary file systems in unicore32.
> I will submit a patch for generic-version stat.h for discussion.

But the generic version of stat.h goes together with the generic version of unistd.h,
which the code you submitted is now using.

I understand that you are using a patch to use the traditional system call table
right now, on top of the generalized code. Can't you use the same patch for the
stat.h file?

	Arnd
