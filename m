Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737Ab1JGJwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:52:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1JGJwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:52:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Williams <steveicarus@gmail.com>
Subject: Re: MODULE_LICENSE("GPL") not working for me
Date: Fri, 7 Oct 2011 11:52:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <CAO3ZPq18MfYTu_6_RLZvvB0_0aFwTR3AfzKbKMRp5Bzt62Frnw@mail.gmail.com>
In-Reply-To: <CAO3ZPq18MfYTu_6_RLZvvB0_0aFwTR3AfzKbKMRp5Bzt62Frnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110071152.41357.arnd@arndb.de>
X-Provags-ID: V02:K0:+apONKq6BdDiwb+cAuf38Fa6Cp4DtSp07i4ER8q8uZC
 wCprtBXPOqEDb8LNU0kWC2CZR/wr5KyH8zBrkjcglOVTqGukZ4
 Dk0x6dMlXPkbmmN/QlAMZZPG7JSsICqBvVWMOmKyauaW4WxnRH
 ANCvzZaHPASD9eo+WoNJJGRAvhdtvq44Sg/g8zj1mSypo0l8bs
 H7WbMhZFHQjIHAlSvdERTUjlJV0AGWeOJJRlRvssuFgG1hhlVh
 rwNLtGwSplLdACY05/G/svYLMbey8K6v6yeV97RE2q5IQ1BGlt
 9FAwWLqa6IujVMLEC/6vf8/xB9yU/aWQq15qlV5RU3uSMjj/95
 qCNEuQz8aRYnqCm7+JUE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 October 2011, Stephen Williams wrote:
> 
> I have some large drivers for use in embedded arm systems, and
> I want them to be GPL, because I want to use some symbols exported
> as GPL, and also because I just wanna. But it is not working for
> me. I've attached my Makefile. I'm building from outside the kernel
> tree, but that should be OK. (right?) I'm using the following script to
> actually build:

It's usually much easier to build from within the kernel tree.
Just put the driver into the drivers/staging directory and use
the regular Makefile/Kconfig logic to hook it up with the build
system.

	Arnd
