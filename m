Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3AIP0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:26:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3AIP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:26:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] Proposed removal of IS_ERR_OR_NULL() (was: Re: [PATCH 1/4] gpiolib: introduce descriptor-based GPIO interface)
Date: Wed, 9 Jan 2013 15:26:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <20130109150427.GL3931@n2100.arm.linux.org.uk> <CACxGe6vXmJ5F4MC826BPSui1pckEzNa5-iaRSXa6TqHdp=UYzw@mail.gmail.com>
In-Reply-To: <CACxGe6vXmJ5F4MC826BPSui1pckEzNa5-iaRSXa6TqHdp=UYzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301091526.28290.arnd@arndb.de>
X-Provags-ID: V02:K0:GUL51d3s6E1A9kb/MhcXdo91twx2XcStVD8RwWSKRS/
 vy8e7hbvfe9RNpkWQ6IAc0WH2xe4kaL7SdzbBKVr9o420oMiq5
 dr3PQPEkHJKMqCu8EA6key4ufrRbN11wS+HXSexG6+09Rzk4wk
 MUt01xrrQQOzOpbSWgpf2KJEQhDxjx1v3/2ExWIA1QaCcdDp5A
 WJYiOweX702+fjRyghsDaoWaq9UUff/0k+BsAMUEDp6to03byP
 IYRkBChKYucwMIPQmYepBlRdeIAAd2fivnNl0RD781k3zXTk2K
 CN8BF2fhAT9Rl0iN5ZuibLm4gDTo7DoXxeg9fqt9YGdqLqp5vX
 Rb2hqaoS+DjdOZnrL+OQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Grant Likely wrote:
> > Suggested-by: David Howells <dhowells@redhat.com>
> > Tape-measuring-service-offered-by: Will Deacon <will.deacon@arm.com>
> > Victim-for-firing-sqad: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Arnd Bergmann <arnd@arndb.de>
