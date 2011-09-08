Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1IHXM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:12:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63229 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1IHXMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:12:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 31/62] driver/char: irq: Remove IRQF_DISABLED
Date: Thu, 8 Sep 2011 18:04:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Clemens Ladisch <clemens@ladisch.de>, Corey Minyard <minyard@acm.org>,
        Mark Gross <mark.gross@intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        openipmi-developer@lists.sourceforge.net
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-32-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1315383059-3673-32-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081804.06083.arnd@arndb.de>
X-Provags-ID: V02:K0:+JGvvvAWleZ0lcJQEAy9hVSo83+S/8/Sm/BScanStRx
 losJ2XZ/xuqql+3xl368qkI/c7zao4+PKAkTGHOLsHVlNuLpT4
 EN5iIEhHvaBI6B7mGzHG79dgI0JNp+Z4mLlovkJBAXtpm2q+fg
 UqfwIjmVW9exKzKfBZfzPJzpsi9SLXZ+gfijw8CXzzhKwn7yLU
 wLtg0bd+G0Cev7zeWc3QOebXBzHNKY/4VGEVnGfKS3Qmgihk3A
 ezNa5a8G0gv+h9BTP182KPSs0/cRDTpRXrAfTETKmuMYUUTUVP
 Gdbz8jw5EMEv0jDvkY68JZnlCf61LA9yB5MceX1999GvN1UJbB
 W1nMhLIPY+V1JfD829rk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 September 2011, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
