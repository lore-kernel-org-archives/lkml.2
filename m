Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2KLOWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:22:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2KLOV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:21:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC PATCH v1 31/31] ARC: [plat-arcfpga] defconfig
Date: Mon, 12 Nov 2012 14:21:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211071406.58304.arnd@arndb.de> <50A10540.3080005@imgtec.com>
In-Reply-To: <50A10540.3080005@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121421.52020.arnd@arndb.de>
X-Provags-ID: V02:K0:0fHzedtN5o2Zod5qqLj1Jvcic/MUFxWkgTyEtmKzTFG
 hhnqzdOZKc2/IijcrHyedPt4U6D5rw48kH7fW00gYnpDElyX1H
 AQ8bbt3WpWceopcvfw9rWekAotxCBFwWb35viJwXMdFP5KJiU1
 KpQawCW09g42mNE4TJHASo22h+r0j7A/gxg90lYWvdzhV0UUcs
 t9AqQk9N7P8yw5Uhg1GtUc27PfwU8Ln3dQz05I7oFO1LkTeecy
 MDbaxtalnu6ldtrIvqpykN82IjCUpzrmr+a8GdXnb4gIMtlrik
 xsvxjRd6GuHGTlOAeRGo71NUNVI/a0yV+OQVdnFc5EOI5rCQQn
 RbK9+ao9Bfr24WhLwGDk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, James Hogan wrote:
> > 
> > Please use "make defconfig" to generate minimal defconfig files, instead of
> > copying the entire file here.
> 
> I think you mean "make savedefconfig"? (I think "make defconfig" loads
> the default defconfig).

Yes, that's right. Sorry for the typo.

	Arnd
