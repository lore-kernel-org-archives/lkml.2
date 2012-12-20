Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab2LTIv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:51:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2LTIvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:51:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC Patch v1 45/55] ARC: unaligned access emulation
Date: Thu, 20 Dec 2012 08:51:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <201211121400.13046.arnd@arndb.de> <50D2C78B.4060109@synopsys.com>
In-Reply-To: <50D2C78B.4060109@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212200851.15350.arnd@arndb.de>
X-Provags-ID: V02:K0:guYCYYBCWmvww0v4ygt9D03mrYbSmYbXxa3cMn5peRu
 sQQWxsrvs893JHumzKmH6u3sczSPhR2T4lMtAESagGtzLSjcOL
 luHO9Rm7uz63Sa2hsNkxNCbaHIuTxnvxWaydmZoO4cxtSzvpZD
 r7Hd1Rt/sfUYqSHHz2SGmkXCG9KT3kL/pA/yHhXtZskSwpgGAr
 TWizo7wagoT66SVCqu/FuzkfJuF1937K07aKxvC71fFrUYOrnQ
 A4+md8Oudujxw0zqtNlAKEkOtxTmVXyBO/BmKj6SOK3cIAD9h4
 HK2kgj5xQbqKRRYelpjp5rtmCnVmOtUxkZhSaGxZ9+SqPnMoh/
 s8ZLVQsvwuyAvhvRNglo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2012, Vineet Gupta wrote:
> Are you OK if we keep this support build time - provided that once it is
> build time enabled - we have the additional runtime sysctl based
> toggle-ability as you suggested.

Yes, sounds good.

> Only one of our customers need this feature and this gives people
> reasons to moan about the kernel .text size and such.

Ok.

	Arnd
