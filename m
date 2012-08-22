Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2HVGez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:34:55 -0400
Received: from mta05.xtra.co.nz ([210.54.141.250]:61231 "EHLO mta02.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751732Ab2HVGev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:34:51 -0400
Message-ID: <1345617278.7491.4.camel@gitbox>
Subject: Re: [PATCHv3 3/9] serial: vt8500: Add devicetree support for
From: Tony Prisk <linux@prisktech.co.nz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-fbdev@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroup.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, linux-serial@vger.kernel.org,
        rtc-linux@googlegroups.com, Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Date: Wed, 22 Aug 2012 18:34:38 +1200
In-Reply-To: <20120821231255.71a7515a@pyramind.ukuu.org.uk>
References: <1345582058-2291-1-git-send-email-linux@prisktech.co.nz>
	 <1345582058-2291-4-git-send-email-linux@prisktech.co.nz>
	 <20120821231255.71a7515a@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 23:12 +0100, Alan Cox wrote:
> On Wed, 22 Aug 2012 08:47:32 +1200
> Tony Prisk <linux@prisktech.co.nz> wrote:
> 
> > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> > ---
> >  drivers/tty/serial/vt8500_serial.c |   37 ++++++++++++++++++++++++++++++++----
> >  1 file changed, 33 insertions(+), 4 deletions(-)
> 
> Can we have a comment attached to a change this size. In particular one
> describing why it gone from 4 to 6 ports, and why the port id twiddling.
> 
> Is there a reason you can't use the device tree port id ?
> 
> What are the regression risks for existing users expecting the pdev->id
> binding ?
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Sorry Alan,

The original patch was very simple, but I revisited it to fix other
issues and forgot to add the relevant comments.

Port size is changed to fix a problem - WM8505 actually had 6 uart's
defined in platform data but the vt8500_ports variable was only 4.

I have added devicetree port id support as well.

No regression risks as the entire platform is being converted to
devicetree and existing code dropped in this patchset.

Patchv4 3/9 to follow.

Regards

Tony Prisk

