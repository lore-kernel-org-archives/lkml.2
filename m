Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab0DOHha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:37:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47298 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab0DOHh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SSx2wE9fS7qkGnroheqa5IBs6N69Pi7y2rtNjBtM2Q40/MFBQbhD928QdyToeBP3fW
         iR9O1phkRHS7eDGZxkf8RvXo4h86jEN+CtC2pUjVULa4URMDtJRpX7ttDoWvozD+w6Zv
         atcl2zBqPn6vMORS5lFPnZs1vlAW+9KdlyHkk=
MIME-Version: 1.0
In-Reply-To: <s2g7b6bb4a51004150012zc6145d27v913dfe55924fff0a@mail.gmail.com>
References: <20100413025228.GC10860@localhost.localdomain>
	 <m2v7b6bb4a51004142312ze69796ak87d4ee65f6dd5529@mail.gmail.com>
	 <o2w628d1651004142317n438d21e4t359c9661c2c00926@mail.gmail.com>
	 <s2g7b6bb4a51004150012zc6145d27v913dfe55924fff0a@mail.gmail.com>
Date: Thu, 15 Apr 2010 15:37:25 +0800
Message-ID: <u2p628d1651004150037tceb61055t7633c1902716f8b3@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Make config Filter access to /dev/mem default y
From: wzt wzt <wzt.wzt@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       x86@kernel.org, zippel@linux-m68k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm curious about the result if you open this option to yes.
here is the result you want see:

Program zealot tried to access /dev/mem between 407000->409000.

my ids can't work around.

> What's the result for kernel w/ CONFIG_STRICT_DEVMEM ? does it prevent
> your rootkit?
my program is not a rootkit, if you want to see some backdoors, please
read the Mood-nt2.3 or suckit source code, have fun.
