Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab3AIWdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:33:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59446 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089Ab3AIWdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:33:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 03/10] goldfish: tty driver
Date: Wed, 9 Jan 2013 22:33:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
References: <20130109142212.9239.62026.stgit@bob.linux.org.uk> <20130109142318.9239.14079.stgit@bob.linux.org.uk>
In-Reply-To: <20130109142318.9239.14079.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301092233.10166.arnd@arndb.de>
X-Provags-ID: V02:K0:Fpin4g9nAqM1iu15ZssRztfs2XXRqsCUXaCmJThOx1z
 0/T4Rer+hSPUEEFJa61PfD/reqR7NRWDqTFNchXTn2XQwYxZhJ
 WWdME1N9JWuSpO3KBBXwhwoaWlDh/Es+xfF8fiCpjbZN4fGAr5
 IGZL7ID/FXqcX6QgEvDtaR/eH+L4cqp7/YI7jOuynSV4WiDnQZ
 XZdo5BFSYDCYGAQvXZGL9Wrz25NUNxPYvBD/4akYBiZUUxV250
 3jDuKFEowPmelkjCmTv5KpKpKic4PUw+49R8th2IqQWRVpBv5a
 aQfuz5KsD9EGRzoTzJEUz8zmgnqIV78ntfg0JYrhc3UZyyUFwK
 KH5/gXU+Tm6U9T+Dn+is=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Alan Cox wrote:
> +static int __devinit goldfish_tty_probe(struct platform_device *pdev)
> +{
> +       struct goldfish_tty *qtty;
> ...
> +
> +static int __init goldfish_tty_init(void)
> +{
> +       return platform_driver_register(&goldfish_tty_platform_driver);
> +}
> +
> +static void __exit goldfish_tty_exit(void)
> +{
> +       platform_driver_unregister(&goldfish_tty_platform_driver);
> +}
> +
> +module_init(goldfish_tty_init);
> +module_exit(goldfish_tty_exit);

The same comments on __devinit/__devexit and module_platform_driver
that I made on the bus driver apparently apply on this patch and
some of the others.

	Arnd
