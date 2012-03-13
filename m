Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270Ab2CMJw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:52:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60062 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964990Ab2CMJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:52:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 21/35] Split arch_align_stack() out from asm-generic/system.h [ver #2]
Date: Tue, 13 Mar 2012 09:11:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233935.13888.29261.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233935.13888.29261.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130911.59138.arnd@arndb.de>
X-Provags-ID: V02:K0:OCz6XH71S6GpeqwspIuayBtmTBMBbuAPSDiU4XBv8UJ
 CcWNeBvXX8zX4p/XjmaM8GoFvSYZ7YMBAp2Bk6ZLahKOB0qSYv
 IBXKC2+IKu0f9TTf+InYIwzlePxKzDG15MQobk1vqvsAO4QHkO
 isk1oXQ0U9fSV3fUThFR7nHMMiq7sQYkzTUaS/VE38COq4n52g
 +KWgrpb/d+jV+z0Ns3+Uyl91jQrnMaVeuWo+I2LOwFyq7c+Mao
 ICY1HSP8AgO+JBa49G36zbNwpVRs6uP1aKUUceRx2U00y3gumG
 stgLlDXcrzSHWIlTXUipESNzrMR2LlSDo55Cbq4I5UnMhwNAhT
 l4PiB/M/CJuZu/ruUtI4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2012, David Howells wrote:
> Split arch_align_stack() out from asm-generic/system.h into its own header of
> asm-generic/exec.h as part of the asm/system.h disintegration.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

