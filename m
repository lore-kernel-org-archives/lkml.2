Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0KJKPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:15:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0KJKPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:15:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Wed, 10 Nov 2010 11:16:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1288897198.git.richard.cochran@omicron.at> <201011080756.50930.arnd@arndb.de> <1289338622.9434.46.camel@localhost.localdomain>
In-Reply-To: <1289338622.9434.46.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011101116.08038.arnd@arndb.de>
X-Provags-ID: V02:K0:HtCaPP2m9jdPLKwyrw1E5JKSaqqTwMOqAkEb86A+EkR
 SmWgdt3dNLquhffUbPc7JayrLHlGje2oZLFwxYaYENnc03EBSF
 xbnVPdlPImoHE0IbaOh8dE39G1MiHQs0nk7j47Hx1mIHYdV6+I
 KCyWNM2Yp407dJVwS+8AwV7UGs0TbdOvau6oZmHdMN85TTcD7g
 dNe55t0jc0BGmDkxv+gyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 November 2010, john stultz wrote:
> I wonder thought if it would be worth having a syscall to convert from
> fd to clock_id so it could be more flexible in the future. But it may
> not be worth it, as we're probably already limited by the cpuclock
> implementation.

If the file descriptor comes from a character device, we don't even need
a syscall, it could simply be an ioctl on the device.

	Arnd
