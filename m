Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2KHMfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:35:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2KHMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:35:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: wwang <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v7 0/3] Add modules to support realtek PCIE card reade
Date: Thu, 8 Nov 2012 12:34:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Alex Dubov <oakad@yahoo.com>, Chris Ball <cjb@laptop.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "bp@alien8.de" <bp@alien8.de>
References: <cover.1351481260.git.wei_wang@realsil.com.cn> <1352347282.60054.YahooMailNeo@web121002.mail.ne1.yahoo.com> <509B4363.7080905@realsil.com.cn>
In-Reply-To: <509B4363.7080905@realsil.com.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201211081234.43449.arnd@arndb.de>
X-Provags-ID: V02:K0:Fxj7vPCOdW9K6kfeofB5N9CnYIlXbYaNg29E4T36J2Q
 thnXQL0b+nfA4/VsUlq6q7kvIG2AttFD2VgY7HtlLOi5DuCt3F
 RKc6XxM961HUKxheM8tqs4CzADf59Q+NLG8Bi2/1mGsLmgytfF
 3qCOSYk8YIAQdGsD0QslfDbwNg/XyDsantAikx7J6zPEKE+gVV
 zDseAdHyTwlEmyrmHuWsO/8E+RbcKdJOxzUqMS+CjIsdpbOQo1
 dA8aY7A7qUq5rz7Kg+3dd/gBPGczyEBV4A4fUhwF9GN5B4jrdn
 +btKJy0Q5H08xoBG54h9OSha/p6o9xG1rQ8Wdt0c2kOGKXmfIq
 eiukXDOhOsQ14l2+CffM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012, wwang wrote:
> 
> 于 2012年11月08日 12:01, Alex Dubov 写道:
> > Hi,
> >> Do you have any comment on the MEMSTICK part in this v7 patchset? Can
> >> you help to merge the patch to the kernel tree?
> >
> > I'm afraid that presently I don't have much time to look at the memstick related stuff any further. Hopefully, somebody else can step in and take a look at your submission.
> >
> > Sorry for that.
> >
> Hi Greg & Arnd:
> 
> Can you help to review the MEMSTICK part in my patch and merge it to the 
> kernel tree? Alex is a little busy now and I can't find any other 
> maintainer who can take care of MEMSTICK subsystem.
> 

I don't know anything about memstick specific questions, but I looked
at the code and it seems entirely reasonable and well-written.

Acked-by: Arnd Bergmann <arnd@arndb.de>
