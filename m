Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab2H0KGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 06:06:54 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46737 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2H0KGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 06:06:49 -0400
MIME-Version: 1.0
From: Yang Bai <hamo.by@gmail.com>
Date: Mon, 27 Aug 2012 18:06:27 +0800
Message-ID: <CAO_0yfNxa9m0BR-MxMezC-CZ8M=JkOmnLrpWyUcti-cT8f3zzA@mail.gmail.com>
Subject: Q: What will happen if I insmod a new version driver when it has
 already been statically in kernel?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We have one driver which has been statically compiled into kernel, and
now we want to upgrade it. But we only have a new version module for
this driver. Could I just insmod this module and make the new driver
work?

If so, what happens to the static old one?

If not, Can we upgrade this driver without re-compile the kernel to
make the in-kernel driver out or module?

Thanks,
Yang
