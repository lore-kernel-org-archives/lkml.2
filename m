Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1DAJJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 05:09:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1DAJJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 05:09:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] unicore32 fix: remove arch-specific futex support
Date: Fri, 1 Apr 2011 11:09:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Paul Mundt'" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <01eb01cbeeb7$30390460$90ab0d20$@mprc.pku.edu.cn> <201103301440.03479.arnd@arndb.de> <004301cbef8c$b0bf0640$123d12c0$@mprc.pku.edu.cn>
In-Reply-To: <004301cbef8c$b0bf0640$123d12c0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011109.23966.arnd@arndb.de>
X-Provags-ID: V02:K0:6f8ZvKs/ZDMUx3dAArUn6TvMHD8WgxWWPOdN4Anb12u
 pUyURsfWQVZgNBBp0CWMJz5J6eVCttZ8iQ3wOdbugOX6J5WrX6
 t3AF44rnHldC5lZZFVuL9+2z2y/cQjh+ZS1C+TRSnjKW9pUx4W
 rdKCH9JLuDtCs+zH5Jc7OUdOZMs6xObyqMsCcH9MOod1ilJJHQ
 9rm1jVZx0C/GYcNP9poKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 March 2011, Guan Xuetao wrote:
> For cmpxchg, we have both system call and kuser_cmpxchg supports in old abi
> which are similar to arm.
> The performance of system call version is too poor,  so it could be only used for test.
> 

Let's forget about doing futex support for unicore32 then and use your original
patch.

Acked-by: Arnd Bergmann <arnd@arndb.de>
