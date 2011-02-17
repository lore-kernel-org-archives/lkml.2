Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab1BQSDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:03:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55137 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395Ab1BQSC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Chou <thomas@wytron.com.tw>
Subject: Re: [Nios2-dev] [PATCH 4/4] MAINTAINERS: Add myself as a maintainer for  altera_uart/altera_jtaguart
Date: Thu, 17 Feb 2011 19:02:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Tobias Klauser <tklauser@distanz.ch>, nios2-dev@sopc.et.ntust.edu.tw,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <cover.1297245277.git.tklauser@distanz.ch> <04c107d8032cbaffada91066c1d010b9274aebe1.1297245277.git.tklauser@distanz.ch> <4D5C9314.8030101@wytron.com.tw>
In-Reply-To: <4D5C9314.8030101@wytron.com.tw>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171902.41784.arnd@arndb.de>
X-Provags-ID: V02:K0:YXlc5b4+qVnFogbE3ap5Rpqqh14fka08dU1m1giTLs0
 jvpkCyobr/TzaH92p8A3nIZm57/KoZoD0a9zzExQnghfvDDCL8
 mI+C8saLydv1PXLcNPQygm9kq+gp7QZIlKHkGLpYXiguWiPzYC
 OmJnlS8p0Rpyteu+CZ+AnTnuwbTQHueLUd/5iwuy59vXUTqwKU
 pm4ylaJQi7cNM0T9t7K/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011, Thomas Chou wrote:
> As we get more drivers merged into mainline, we might consider adding a 
> general entry for all altera related drivers to our mailing list. We 
> could add "F: arch/nios2" to this entry in the near future.

On a related topic, are there plans to submit the nios2 arch code
for review any time soon?

I'm usually reviewing all architectures that come in, and unicore32
is almost ready to go in, so there is room to start reviewing the next
one.

I expect nios2, lm32 and c64x to be submitted this year, but I'll
probably only be able to review one at time. First come, first
serve.

	Arnd
