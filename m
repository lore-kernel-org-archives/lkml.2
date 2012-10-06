Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2JFMyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 08:54:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2JFMyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 08:54:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Please add back the asm-generic tree to linux-next
Date: Sat, 6 Oct 2012 12:54:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210061254.45804.arnd@arndb.de>
X-Provags-ID: V02:K0:JibqgX5vgCHaabw9LY7lQxnWl92d5AxXgQvn5Bg7no6
 YbYXsrL33hIiAQEPVOuRjln4eu8trWQrv9PRa598ly3wb+fTyO
 zyjKj2lCpdQ0X5YIxYhEnhAXpeEOEpWeBhQJESVC4+jonzw80/
 +zNI0QX9lMJVAL+z6Vpb5o0oMim6vyRVo88R5R9j9rJ9P5H+Qs
 HRDiih3yRxuc7XsUP6yUo0XaAgMZujhhummb2YNKGnbMFzzXxN
 BC7Sa0OViu9esztAB1fyR40Gb46olpuKgcLscvqiT/24fLbQW9
 NHPM5NpgCUsWv7SyP/EXql+cCzQZxx68tEpaJLoxLU6fFkdl4c
 YlYthr3/OKqU17NpOmyg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I haven't used my asm-generic git tree for the last year, but now I have some
patches in it again. I was (ab)using the arm-soc tree for now to get the
few patches into linux-next, but the URL is still listed in the MAINTAINERS
file and I should really be using that one, since it is mostly unrelated
to the arm-soc work.

Pleas add
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git master

Thanks,

	Arnd
