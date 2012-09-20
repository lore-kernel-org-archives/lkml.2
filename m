Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2ITVwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:52:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2ITVwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:52:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] module: add finit_module syscall to asm-generic
Date: Thu, 20 Sep 2012 21:52:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
References: <20120920200702.GA18807@www.outflux.net>
In-Reply-To: <20120920200702.GA18807@www.outflux.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209202152.38630.arnd@arndb.de>
X-Provags-ID: V02:K0:8cK7RUPedAEeScR0HAPeASRyxXn6XrnJrbsdMmXXoqz
 0gGQazhc7kjWQ3/3cBECdJ7rvmNR5PLWw6wDN5tyQhLYMxr3Uj
 Szz9+0gqgXi4QLwRClpuKS+MwvT6ocORvTcUlPD1g+ybxGP9Ua
 vXiL03+RpYZOmQg05jKWHMNN2Mg6BBgb27SWsawRwkiNe4cdQJ
 XTeHNlc3L3AnAM6u1b7JGGRL2fQ/4J9p4l2KoO/bt4jFbBs8Vf
 aKyx0hkwpjfcdXx+yb0SRC6QvgnNBha5St0GwaOXwX22781oOy
 WyteS+qRlX8//sBOJRU88GhDAOQjNIrmpn2UBagGXtsMQlv/Eq
 h5Ar2K/uWIbSD8IRBb04=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2012, Kees Cook wrote:
> 
> This adds the finit_module syscall to the generic syscall list.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This depends on the finit_module patchset in Rusty's tree, based on
> https://lkml.org/lkml/2012/9/7/559

Acked-by: Arnd Bergmann <arnd@arndb.de>

Please queue this along with the other patches.
