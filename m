Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227Ab2CMJwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:52:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965016Ab2CMJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:52:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 17/35] Make asm-generic/cmpxchg.h #include asm-generic/cmpxchg-local.h [ver #2]
Date: Tue, 13 Mar 2012 09:00:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux@openrisc.net
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233858.13888.34822.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233858.13888.34822.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130900.41993.arnd@arndb.de>
X-Provags-ID: V02:K0:LCfO4e0NPOP8w9AkYNUBfb2yWIJkavKMIMjCc7Fl8SV
 FBvd4r+Bu2hAWLGQWJVJrAb8i+RJmiGKBJz6WJN2ADnBYzigSt
 1P+8W5iRpUXxOJtA+beQbvmR3Z/nr/mLEu9MQia5VxTP2niO+q
 eQFX1F8mC5hVLzggOW12qZuV7H47cj5pM87EZl7WPuVH3TLhsi
 61ghMu4fNcTfv/256db/pSCW6t5fdM0QznhdZS68w3EB++VTna
 LVayT3+oYKAfCNMktAG+uPdMI5TiDO4VvXiYAvNSkEPQH8d9fY
 ZYDyi5FwOKL/L+dLeXaXTsNy5rY+s+3EfgoJDQFWa91gkIUMAU
 6Aq5dj8Bqjx52YaXBKY4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2012, David Howells wrote:
> Make asm-generic/cmpxchg.h #include asm-generic/cmpxchg-local.h as all arch
> files that #include the former also #include the latter.  See:
> 
>         grep -rl asm-generic/cmpxchg-local[.]h arch/ | sort > b
>         grep -rl asm-generic/cmpxchg[.]h arch/ | sort > a
>         comm a b
> 
> This simplifies the disintegration of asm-generic/system.h for arches that
> don't have their own.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I would suggest we merge this one through the openrisc tree, along with the
other asm-generic patches in your series.

asm-generic patches tend to have dependencies on other stuff and they
rarely conflict with one another, so generally my preference is to have
them sent by whoever needs them, with my ack.

	Arnd

