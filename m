Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1IYJER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 05:04:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1IYJEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 05:04:16 -0400
Date: Sun, 25 Sep 2011 11:04:17 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: kernel@kolivas.org
Subject: Re: BFS cpu scheduler and skip list implementation
Message-ID: <20110925090417.GA19813@fancy-poultry.org>
References: <201109240945.58879.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109240945.58879.kernel@kolivas.org>
Organization: private site
X-OpenPGP-KeyID: 0xE9002778
X-OpenPGP-Fingerprint: C661 CE20 7105 B0DB 49B5  CDB2 298C 801B E900 2778
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
X-Provags-ID: V02:K0:Bmzdu3Ej4epmSrKS+5CCiZo3hnaC07XtwdUaIh+8Yap
 RUbxgV7mlj9uUc9oOkPJKcYYFWMcur55H8YrEL4j8PIsPFol+x
 JCCbTZSbZG6+EJxrflT9FS7A9CLkueOv+OcveyIyeqJelgbPJm
 AKuoBmeJstnhSg66EGFIwkjPLsKh9u8ormGUSXvcuWWw/LgjSl
 vw0dUrdYgKabP4GS9mwh2j1osdHYgeYeOyS+RDJbW7lCtQH2aj
 6zA4MhKaw7YL4xIt4s+fI/sGVRMnyKmrvYKNeBULaw96Vk8FZS
 kqFpavARDLePrEU/ItACb0hVYHw569ycm/sQNYzMBtAZ1MMwCQ
 Tx8bzdEuUV8hUIdJaPgENe6C50lzfjx7cJW/o0Mb/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.09.2011, Con Kolivas wrote: 

> Try it out, see what you think.

Your patch applies cleanly to 3.0.4 vanilla, but compilation fails:

[....]
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1504: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1505: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1507: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1508: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1511: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1513: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1514: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1516: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1517: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1521: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1567: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/sched.h:1568: userspace cannot reference function or variable defined in the kernel
/usr/src/linux-3.0.4/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel
make[3]: *** [/usr/src/linux-3.0.4/usr/include/linux/.check] Error 123
make[2]: *** [linux] Error 2
make[1]: *** [headers_check] Error 2
make: *** [vmlinux] Error 2

