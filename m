Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0KIPD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:03:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0KIPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:03:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 6/6 v2] ARM: Add support for the display controllers in VT8500 and WM8505
Date: Tue, 9 Nov 2010 16:03:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexey Charkov <alchark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <201011080947.37522.arnd@arndb.de> <AANLkTikC9j2U3VUbEmfgH555Zq1sSO-hVtpg_k7hLFPS@mail.gmail.com>
In-Reply-To: <AANLkTikC9j2U3VUbEmfgH555Zq1sSO-hVtpg_k7hLFPS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091603.31667.arnd@arndb.de>
X-Provags-ID: V02:K0:hPsJG13M+vXll3vbD8v+oyACvGS4trtyCoztXa+e/A2
 J/pju+mjmiqbBN6zSt3EWaoQVngV9knYwcgIatZiijx43gKp61
 ME5nyfx1bsgohQXvIK2vOctCh2t1mPimhAclmBgQFestF4QFBk
 BYHyVkwJcVaSQlr8MV9rvZkrlQrHWtawkOlg5/UVH/dwROZ/16
 gs+JwlZRoNTOQfacBprkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 November 2010, Alexey Charkov wrote:
> Quite frankly, I would say that all SoC framebuffer drivers are quite
> similar ;-) Register offsets, timing formats, accepted pixel formats,
> buffer alignment requirements are all different, so I do not really
> believe that there'd be much benefit from introducing another
> abstraction level. This is open to debate, of course.

Ok, I took a more detailed look at the code now. You're absolutely
right here.

	Arnd
