Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2HVGo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:44:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab2HVGoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:44:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 3/9] serial: vt8500: Add devicetree support for
Date: Wed, 22 Aug 2012 06:44:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Tony Prisk <linux@prisktech.co.nz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-fbdev@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroup.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, linux-serial@vger.kernel.org,
        rtc-linux@googlegroups.com, Stephen Warren <swarren@nvidia.com>,
        Alan Cox <alan@linux.intel.com>, Mike Turquette <mturquette@ti.com>
References: <1345582058-2291-1-git-send-email-linux@prisktech.co.nz> <20120821231255.71a7515a@pyramind.ukuu.org.uk> <1345617278.7491.4.camel@gitbox>
In-Reply-To: <1345617278.7491.4.camel@gitbox>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208220644.18059.arnd@arndb.de>
X-Provags-ID: V02:K0:wnJ8b7+M/b6LaPQWuArNrYPFGCcl/rBuVp3fKTWDtvh
 UHrUCaURp0P+7TmMYcfjxTwmHMb4Z4cTN67Gg1nxwRXR06dhdW
 cmfEOcFxye2LhdDy9UueK8JaB5DMimEEFpiFUeMLzPVLukcekK
 crexcqCjV00AE8WLK3LEsx/oAtMdGK3+n5fcB1DXAIV7tsuKLZ
 hnSIIIwHVcYqyEkNecsOjZqi9M7VR/O0flKcJufflH89Ip/fLz
 ivSzdNq0jvnUklJ61c43OiA9TI0GxGPvB9KFY3RI5+I19c1GHA
 ccQblfml9a5HhRA8GGkB59J6wplazr0KQM5s4XnZuT3FzeRDJi
 6cIhfgu3Zp11FDgqz3jg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Tony Prisk wrote:
> The original patch was very simple, but I revisited it to fix other
> issues and forgot to add the relevant comments.
> 
> Port size is changed to fix a problem - WM8505 actually had 6 uart's
> defined in platform data but the vt8500_ports variable was only 4.
> 
> I have added devicetree port id support as well.

If you do multiple things in one driver, you should normally send multiple
patches as well, each with a description why that change is done.
It may seem silly at first to send out a one-line patch next to a 100-line
patch for the same file, but those cases are actually the ones where it's
most important.

	Arnd
