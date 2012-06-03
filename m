Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2FCLXC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 07:23:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55448 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2FCLXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 07:23:00 -0400
MIME-Version: 1.0
In-Reply-To: <CABexPfEq7cz-nng-gz9TQB=9pyeBFALsRDAPSDbM4HFe=cjxJA@mail.gmail.com>
References: <CABexPfEq7cz-nng-gz9TQB=9pyeBFALsRDAPSDbM4HFe=cjxJA@mail.gmail.com>
Date: Sun, 3 Jun 2012 19:23:00 +0800
Message-ID: <CABexPfGqW-4hTrsPE=dNUsQ84kikr2sAZ=HKckk6sbFbz6quaQ@mail.gmail.com>
Subject: Re: [build error] building failed with sample kernel code enabled
From: Zhihua Che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/3 Zhihua Che <zhihua.che@gmail.com>:
> Hi,
>
>    I was building kernel 3.4 with kernel sample code enabled on my
> ubuntu-11.10.
>    The steps I followed are:
>    make O=xxx menuconfig
>    make O=xxx -j16
>    But it failed and complaint the following:
>
> linux/samples/seccomp/bpf-fancy.c:13:27: fatal error: linux/seccomp.h:
> No such file or
> directory/home/harvey/open-projects/linux/samples/seccomp/bpf-direct.c:21:27:
> fatal error: linux/seccomp.h: No such file or directory
> compilation terminated.


I forgot it.  I've checked the existence of seccomp.h. it's in the source tree.
