Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0ILVrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 17:47:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38658 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0ILVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 17:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=O/HhDgaOEThvvTCm03AhSlRjXyYozV6tkNQP7y24nBKPTjGm2wAhe2iruHnzs7DNMh
         A9JzRqCwwsD8G+b9pfz0z7ta9an71u8pHvmIKDcercE9/9wF1uCEG+Y1YbN+BGRZAY/g
         79fqLVwmqSM3A6Q/DLVjEha8EEWEOeYwFCrMw=
MIME-Version: 1.0
Date: Sun, 12 Sep 2010 23:47:39 +0200
Message-ID: <AANLkTimC5Vz7x9+MNJcewijoyw=Nyr6WWP=YR8cxqarH@mail.gmail.com>
Subject: Regression on UP ARM from commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Jonas_=C5berg?= <jonas.aberg@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
"slub: Remove static kmem_cache_cpu array for boot"
made my ARM 926 UP system hang at boot, if I revert this (have
to back out a lot of SLUB patches for that) it comes back up. (Same if I
switch to SLAB.)

Any hints on how I can get patch around this in a nice way?

Yours,
Linus Walleij
