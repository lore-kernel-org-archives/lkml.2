Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab2CMLd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:33:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab2CMLd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:33:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/35] Disintegrate asm/system.h for Hexagon [ver #2]
Date: Tue, 13 Mar 2012 11:33:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org
References: <201203130916.15118.arnd@arndb.de> <20120312233747.13888.75605.stgit@warthog.procyon.org.uk> <27808.1331632900@redhat.com>
In-Reply-To: <27808.1331632900@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203131133.32241.arnd@arndb.de>
X-Provags-ID: V02:K0:KVoF3J5HUtLoJw6xZX3vXKRdE4+DcAzXyKrsfOVx1kZ
 swj/AcvF45+HeFqfRMBPOEi/b0xM4tkwIkXyMXd0jeAZD9LP61
 9/3O/tRqtH3MkZU819nRTaeebmzeTgxEXXfOhXZ0pzevPUvF3m
 jttbeROyg/GvmMUA1ytzy3n6I2rb7ya/XgNY7g/StlYt2NvnrG
 S+N4lIMKytppShJmH7joJBwsdbrLzfIySupHE7OJ+CTy7syrST
 mmW77kwUYXnwI0gtM9W1sGUtmbklsTUgqhxVz4s6WmAu+2w8Vp
 y5y6hpDLFNEAK5zMO4NhYs79pVXKK/FZU94ITvcX7lpyhlk3r/
 exPlfvqxaXRSh/WGAmdg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2012, David Howells wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > Looking at this example, it could easily use the asm-generic versions of
> > switch_to.h and barrier.h, but that would complicate the dependency chain
> > again.
> 
> Yep.  The plan is to throw more patches on to the end of the series to
> consolidate those.
> 
> In fact, I wonder if we still really need the switch_to() macro wrapper, or
> whether we could replace it with an function, inline or otherwise, that
> returns the macro's third argument.

Sounds like a great idea, yes.

	Arnd
