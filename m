Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2BQUNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:13:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43708 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab2BQUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:12:59 -0500
MIME-Version: 1.0
Date: Fri, 17 Feb 2012 18:12:57 -0200
Message-ID: <CAOMZO5CarXUJ1XVJMWCEt1AXvnE5Gvunou_8nydjLmPVkZERMA@mail.gmail.com>
Subject: ARM: __enabled_CONFIG_NUMA undeclared
From: Fabio Estevam <festevam@gmail.com>
To: khlebnikov@openvz.org, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Building today's linux-next for ARM:

  CC      arch/arm/kernel/asm-offsets.s
In file included from include/linux/mm.h:8:0,
                 from arch/arm/kernel/asm-offsets.c:14:
include/linux/gfp.h: In function 'gfp_zonelist':
include/linux/gfp.h:267:1: error: '__enabled_CONFIG_NUMA' undeclared
(first use in this function)
include/linux/gfp.h:267:1: note: each undeclared identifier is
reported only once for each function it appears in
include/linux/gfp.h:267:1: error: '__enabled_CONFIG_NUMA_MODULE'
undeclared (first use in this function)
make[1]: *** [arch/arm/kernel/asm-offsets.s] Error 1

, which is caused by commit 053361e1a (mm: replace NUMA_BUILD with
IS_ENABLED(CONFIG_NUMA)
