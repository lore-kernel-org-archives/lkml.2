Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2GBR7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 13:59:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2GBR7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 13:59:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Date: Mon, 2 Jul 2012 16:58:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com, linux@arm.linux.org.uk,
        x86@kernel.org, gregkh@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <4FECB95D.7010200@zytor.com> <20120701104401.GA4352@mail.gnudd.com> <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
In-Reply-To: <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207021658.27755.arnd@arndb.de>
X-Provags-ID: V02:K0:fUdLBtTleIjEKqagdK9Mcs70nQ4CPYQteXVmQoykgtR
 GnIGnG+6vMgeLyGL3sykc+l5SglWjxTiK6KTq5+jpin1Rb43kG
 Aie3Nrtjit4EpD+kgZfFy/XXhzxTDA0a9ijg/+QIYr1rsfvRaA
 Hr0IUgfj87Axyhl7wiPXNmlIYhdBKvqqOF0qoaLKu9i0FP9jhz
 lR9wRtztzKerPTcZs3ZZ9Rudb1eTUQatvyRBBXe/cJ3w4OJUsk
 jSe0YbovEe6PfvU71RQW+bvE8f7bMZLY4USmOM4Dlfy//FlMYm
 1YOWKIouvqeSsHng76CwWthkgxzONFLMntYS97tGubPnxni4AJ
 WYx+zPH/cMk7bcJIezos=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 July 2012, H. Peter Anvin wrote:
> 
> There is no problem with adding ARM or !X86 dependencies to drivers
> now and fixing them later or as required.

Right, but if the fix is trivial (e.g. missing #include statement), it's
usually better to just fix the code.

Also, in many cases it's possible to say specifically what some code depends
on. E.g. if a driver uses clk_get/clk_put, it should depend on CLKDEV_LOOKUP,
not on !X86.

	Arnd
