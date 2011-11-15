Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1KOUMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:12:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1KOUMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:12:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: carla.sella@gmail.com
Subject: Re: BUG: suspend/resume does not work on G62 notebook PC
Date: Tue, 15 Nov 2011 20:12:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4EB53C46.1060301@gmail.com> <20111108010406.GC16800@kroah.com> <4EC2C53E.7020503@gmail.com>
In-Reply-To: <4EC2C53E.7020503@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111152012.29965.arnd@arndb.de>
X-Provags-ID: V02:K0:40LkRD7VnP52/7nj7Qkc2Jr8RCBZ8O56C6AT4qulBEU
 +bxDcF9CdsLvyBGbIrwirzCz6tKKhkM3yhh69kUHgcmuieQ8OV
 JDmwD5AnKcVqguv6z//QeOrAJJzLQA/JYfYOkJt1ItFgd97qJD
 1ZT99PFefM3pi8XwZiEvyhYPjNCSNuYcC7s49AFkQTlFzgUmkc
 VM+hU5/Lu0dr6XOusGEje1JtL0Uh+yJUbcv0X6/in0zmLmaTrW
 5iBhtByOjKcDiEk5bly9OnPim4b5OEwprjvEG+6mrktjK5cEyC
 txGAe0omMhUOUprkvTxIsnQ+lwCOJI0DFXgmiH+HnxYpk5070N
 roIY50ehiDMZ4iCOcjPI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 November 2011, Carla Sella wrote:
> >
> > Can you try the 3.2-rc1 release?
> >
> 
> Hello,
> I installed kernel 3.2.0-rc1 but I'm having the same problems, this is
> the output of "sudo /usr/share/checkbox/scripts/suspend_test --full":
> 

This is most likely the same problem that many people have encountered
using the acpi cpuidle driver. It should be fixed on 3.2-rc2.

	Arnd
