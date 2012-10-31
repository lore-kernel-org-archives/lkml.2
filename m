Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953Ab2JaS5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:57:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36659 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759915Ab2JaS5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:57:13 -0400
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 00:27:10 +0530
Message-ID: <CANBXnM=3r=kkOP0uoZJuJcsZ56fZozxGziBedFLkDH-YT-MQZw@mail.gmail.com>
Subject: linux-next: Cloning error
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I was trying to clone the linux-next tree and it gave me error.

---------------------------------------------------------8<-----------------------------------------------
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
Cloning into linux-next...
remote: Counting objects: 2869337, done.
remote: Compressing objects: 100% (458442/458442), done.
Receiving objects: 100% (2869337/2869337), 575.53 MiB | 241 KiB/s, done.
remote: Total 2869337 (delta 2414758), reused 2836387 (delta 2381920)
Resolving deltas: 100% (2414758/2414758), done.
error: unable to create file
drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c (No such file or
directory)
---------------------------------------------------------8<-----------------------------------------------

Is there anything wrong?

Best Regards,
Adil
