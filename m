Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2G0KsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:48:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2G0KsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:48:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [GIT PULL] PWM subsystem for v3.6
Date: Fri, 27 Jul 2012 10:45:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Eric =?iso-8859-15?q?B=E9nard?= <eric@eukrea.com>,
        Axel Lin <axel.lin@gmail.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
References: <20120726071636.GA28129@avionic-0098.mockup.avionic-design.de> <CA+55aFy9JNZyhdTU+btUbBTKsHN1odX1-as=iTC_L9tZr=Oz1w@mail.gmail.com> <20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Message-Id: <201207271045.14347.arnd@arndb.de>
X-Provags-ID: V02:K0:fi1VOZdWcBATY2pk9dxOOZnemvrdWeokELCX4iDGFuI
 6Ee/P60kCq+LDXUHe0HNi29N+3HHzICSTmIw22hXKJ6L4pqMSC
 XDSfXTZpX33hGsMU5in70iBQ3j0LsOPKKfwhDigVlBcM6jdkao
 uWG7JfCNF/cru/TMH/TUZsadxi3J2wDcVugyWouFJY0nTCeUuI
 vMKuRkE+z2jOwlc2Z4bjofdgz10vuysyAWs4MBmVnvl5kwz0VV
 1iZR1QGi2FfdEm2wCj9fSIdsmKntvdLuoy5nt/JSmyEwBnJQrm
 O8ogj9yO2ss0smXQV0oicizY6wUzItk4onW4umnYmqG1rCkMDR
 VBh+j6n9PGkBhNN/GNWw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2012, Thierry Reding wrote:
> On Thu, Jul 26, 2012 at 02:11:58PM -0700, Linus Torvalds wrote:
> > On Thu, Jul 26, 2012 at 12:16 AM, Thierry Reding
> > <thierry.reding@avionic-design.de> wrote:
> > >
> > > The new PWM subsystem aims at collecting all implementations of the
> > > legacy PWM API and to eventually replace it completely. The subsystem
> > > has been in development for over half a year now and many drivers have
> > > already been converted. It has been in linux-next for a couple of weeks
> > > and there have been no major issues so I think it is ready for inclusion
> > > in your tree.
> > 
> > For new subsystems like this, I really want ack's from the people who
> > are expected to use it.
> 
> At least the patch that adds me as the maintainer is Acked-by: Sascha
> Hauer, who did the original work, and Arnd Bergmann who was involved in
> the review process. Other people such as Shawn Guo and Mark Brown have
> also been reviewing these patches and new patches have been contributed
> by Eric Bénard, Axel Lin, Sachin Kamat, Alexandre Courbot, Alexandre
> Pereira da Silva and Philip Avinash.
> 
> I'm adding all of them on Cc so they can ack this (I'm assuming acking
> this email will suffice).

Acked-by: Arnd Bergmann <arnd@arndb.de>

Very much Ack on the new subsystem. It uses the interface declarations
as the previously separate pwm drivers, so nothing changes for now
in the drivers using it, although it enables us to change those more
easily in the future if we want to.

This work is also one of the missing pieces that are required to eventually
build ARM kernels for multiple platforms, which is currently prohibited
(amongs other things) by the fact that you cannot have more than one
driver exporting the pwm functions.

	Arnd
