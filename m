Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab2JVGxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:53:22 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:58690 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2JVGxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:53:20 -0400
Message-ID: <1350888805.3592.12.camel@gitbox>
Subject: Re: [PATCH 3/3] DOC: PWM: Adding binding document for via,vt8500-pwm
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Date: Mon, 22 Oct 2012 19:53:25 +1300
In-Reply-To: <20121022063558.GB17181@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
	 <1350643135-13197-3-git-send-email-linux@prisktech.co.nz>
	 <20121022063558.GB17181@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 08:35 +0200, Thierry Reding wrote:
> On Fri, Oct 19, 2012 at 11:38:55PM +1300, Tony Prisk wrote:
> > Add a binding document describing the PWM controller found
> > on arch-vt8500 supported SoCs.
> > 
> > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> > ---
> >  .../devicetree/bindings/pwm/vt8500-pwm.txt         |   17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
> 
> I think this can be folded into the previous patch. One other comment
> below.
> 
> > diff --git a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
> > new file mode 100644
> > index 0000000..e8ba133
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
> > @@ -0,0 +1,17 @@
> > +VIA/Wondermedia VT8500/WM8xxx series SoC PWM controller
> > +
> > +Required properties:
> > +- compatible: should be "via,vt8500-pwm"
> > +- reg: physical base address and length of the controller's registers
> > +- #pwm-cells: should be 2.  The first cell specifies the per-chip index
> > +  of the PWM to use and the second cell is the period in nanoseconds.
> > +- clocks: pHandle to the PWM source clock
> 
> I think the common spelling is "phandle".
> 
> Thierry

Will fix the capitalisation and merge this with patch 2.

Regards
Tony P

