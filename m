Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1C0QWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 12:22:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33526 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753988Ab1C0QWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 12:22:30 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19F6pkBHwlFvvG57r61zy13t2p6GrunOtn0TqByHc
	g/AwJ1pm9X2uFG
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] x86: page: get_order() optimization
Date: Sun, 27 Mar 2011 18:22:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; x86_64; ; )
Cc: Maksym Planeta <mcsim.planeta@gmail.com>, mingo@redhat.com,
        kernel-janitors@vger.kernel.org, namhyung@gmail.com,
        linux-kernel@vger.kernel.org
References: <1301215556-8898-1-git-send-email-mcsim.planeta@gmail.com> <20110327113323.GA27825@elte.hu>
In-Reply-To: <20110327113323.GA27825@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103271822.22851.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 27 März 2011, 13:33:23 schrieb Ingo Molnar:
> 
> Just wondering, what's the before/after 'size vmlinux' effect on a 'make
> defconfig' x86 kernel? Does the optimization make the kernel smaller as
> well, besides making it faster?
> 
> Thanks,
> 
> 	Ingo
Hi,

I compiled Linus' Tree (40471856) on my x86_64 machine, once without the patch 
and once with the patch.


size vmlinux-with*
   text    data     bss     dec     hex filename
7996901 1236036 1118208 10351145         9df229 vmlinux-withoutpatch
7996554 1235988 1118208 10350750         9df09e vmlinux-withpatch

ls -la vmlinux-with*
-rwxr-xr-x 1 peter users 18921237 27. Mär 17:40 vmlinux-withoutpatch
-rwxr-xr-x 1 peter users 18921333 27. Mär 17:58 vmlinux-withpatch



Peter 

