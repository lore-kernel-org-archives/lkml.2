Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1JUQxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:53:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1JUQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:53:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tim Bird <tim.bird@am.sony.com>, Joe Perches <joe@perches.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Russell King <rmk@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
Date: Wed, 19 Oct 2011 12:51:44 +0200
Message-ID: <1500345.YeXPhIIHc5@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E9E1944.80601@am.sony.com>
References: <4E9E0B71.9020708@am.sony.com> <1318983248.7569.5.camel@Joe-Laptop> <4E9E1944.80601@am.sony.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kJji6QFJACsKtNj1K0fUL/GJWtqMIav2+l9CddG14T9
 +z7THVKiouRCsI23ZyHTXQco7FRt7+vZ+C9ctTsGXfezureOqv
 9sUBTOspndGYjDes7qsbgSjlo7TPtzCruCZPlvWf7ZpbR+IgmL
 ccquG2jvmikpiDITPMqrION1ESHH8z2Z1f/ShFwbyhuq8qlUd6
 Cy8S2oACdlew1ePWekNkdD4OeFUC0VMd6w6rrhCy+AUHKwX7qa
 40gSOizq0pqwE7qiCj6eiF/Vy7O7/VsIMo6NsZYX/hcw6FR/4B
 FKEKcCNoxi7y+8E4vguo5azN/Nq4SLYTxWZtb4GwGx6vYY+0ot
 Eh9oB5hbqy2E1eCRb3tQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 October 2011 17:26:44 Tim Bird wrote:
> Even inside Sony, usage of 4K stacks is limited
> to some very special cases, where memory is exceedingly
> tight (we have one system with 4M of RAM).  And we
> don't mind lopping off features or coding around
> problem areas to support our special case.

I would imagine that in those cases, you can gain more by reducing the
number of threads in the system. What is the highest number of
concurrent threads that you expect in a limited use case with no
networking or block devices?

	Arnd
