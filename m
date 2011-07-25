Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab1GYMzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:55:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:55:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH -next] arm/mm: fix broken Kconfig
Date: Mon, 25 Jul 2011 14:52:19 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1311542141-16226-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1311542141-16226-1-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107251452.20242.arnd@arndb.de>
X-Provags-ID: V02:K0:PTLe5rnLhkI3627h/EFWLc7BXk3PKfJy5EYHmLehIPa
 HX4m1Si+nlRZ1zoznVvCoxZRTvcdvrU4SxHeO/tvCikyaKLLi4
 5KeTA4fHoOhnV2QYAGALs3Q14AhO+V81fAOTq+Dix+/PmqiugY
 aUnJQp9Yt4mXAynu9w8c5hrFD2zEbMlQIrpA+kpr4ocjSYQEuW
 sa4tn2JII13l5XRNn2qpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 July 2011, Arnaud Lacombe wrote:
> Missing backslash lead to:
> 
> arch/arm/mm/Kconfig:834: invalid option
> arch/arm/mm/Kconfig:835: syntax error
> arch/arm/mm/Kconfig:838: unknown option "ARCH_PRIMA2"
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>

Thanks.

The problem was a mismerge in the tree that I have corrected this
weekend, it should be fixed in today's -next.

	Arnd
