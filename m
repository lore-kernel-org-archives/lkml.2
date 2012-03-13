Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030276Ab2CMJyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:54:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964857Ab2CMJwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:52:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 19/35] Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h [ver #2]
Date: Tue, 13 Mar 2012 09:11:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233916.13888.17108.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233916.13888.17108.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130911.04721.arnd@arndb.de>
X-Provags-ID: V02:K0:lfaWcP+QqJuSgXVlg8h+ccQT9Najrma4FpXdOi+oupT
 d7u6SiTyKYkuOy8qNAFAwxJ2ev9aY72nmSqcAQaYEr5f2OCxer
 BgeMd240lFgmYcDC2Ca70OnZ/SWlz2yh6LdvHcRYYqONkQ7/aq
 IuNy6h7jek2b/sl86eYtao4Z8dJ8vORK1zjytV+9UaUWJqgane
 vtGXksh+mfbqlUlpr4dkjB+Ki14BuvVKwxnAPcl9wvUee4KmIj
 4h8gKF35iEJ8HgOWmAsBtLZe8AktZ0u8zp/rhER4ksIQDwhqoL
 tkQEh82HmZfggpE8+vCaxgknX1DmibsnjWuMds1w9obT/UEakB
 xHGD7wt4/ej3iMFCTbAQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2012, David Howells wrote:
> Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h
> to simplify disintegration of asm/system.h.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

