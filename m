Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1G0O2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:28:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab1G0O2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:28:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Newton <will.newton@gmail.com>
Subject: Re: [PATCH] bitops: Use volatile in generic atomic bitops.
Date: Wed, 27 Jul 2011 16:28:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org
References: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com> <201107271455.39511.arnd@arndb.de> <CAFbHwiSkqpRUv2CW8sqL8XQEkbbvtos2h5UTTX19jeXJNrBOUA@mail.gmail.com>
In-Reply-To: <CAFbHwiSkqpRUv2CW8sqL8XQEkbbvtos2h5UTTX19jeXJNrBOUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107271628.29532.arnd@arndb.de>
X-Provags-ID: V02:K0:7s0xUiPFahP/u1NVkFcUsMllm0ZcvCLK8gviKOwqkAT
 kXgPICdkra9CzHScCPJGFkHDSiUZ2ECyEbULU1JPwRfhJ/eDad
 5A78apQqynuNwtnTGgd9vGS0g7ho6OraLC23CAxB0KiRc83kx/
 sp2y/jiu6QTt1BQl4Pzoi1mpmQAZlRt731XXAl8wzlFGLYcOhT
 XmEUFW0+GDo01tDn4tjdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 July 2011, Will Newton wrote:
> >
> > Have you observed this behavior? The interrupt disable/enable should
> > always come with a barrier that should prevent the bitops from
> > leaking out, so I don't see how this causes problems in practice.
> 
> Yes, although my arch does not have these barriers. Now I see from
> memory-barriers.txt that lock/unlock are required to implement a
> compiler barrier, sorry for the noise!

Which architectures is this?

	Arnd
