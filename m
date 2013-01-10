Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3AJSoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:44:22 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:50348 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3AJSoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:44:21 -0500
Message-ID: <1357843473.6075.8.camel@gitbox>
Subject: Re: [PATCH] gpio: vt8500: Export dedicated GPIO before
 multifunction pins.
From: Tony Prisk <linux@prisktech.co.nz>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linux.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Date: Fri, 11 Jan 2013 07:44:33 +1300
In-Reply-To: <CACRpkdagdO3_6DmKYaCwmx4Jju=E_uy86_QqdKLA3+VK7JNPjg@mail.gmail.com>
References: <1356899374-9395-1-git-send-email-linux@prisktech.co.nz>
	 <CACRpkdagdO3_6DmKYaCwmx4Jju=E_uy86_QqdKLA3+VK7JNPjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 11:49 +0100, Linus Walleij wrote:
> On Sun, Dec 30, 2012 at 9:29 PM, Tony Prisk <linux@prisktech.co.nz> wrote:
> 
> > The vendor does not provide numbering for gpio pins. Vendor source
> > exports dedicated gpio pins first, followed by multifunction pins.
> > As this is what end users expect, this patch changes vt8500 and wm8505
> > to do the same.
> >
> > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> 
> So how many existing userspace applications does this patch
> break? Has this system been widely deployed so a kernel
> upgrade will cause problems for people?
> 
> But applied anyway, unless someone screams about it real
> soon now. That seems to be the only way to get people to tell
> us about their use cases.
> 
> Could you consider adding names to the exported GPIO pins
> on the vt8500 series please? Then userspace can atleast
> try to locate the right pin.
> 
> Yours,
> Linus Walleij

In terms of userspace apps, my best guess would be 'I dunno'. This was
requested by the only end-user to ask a question since mainline support
was added - He couldn't find the external GPIO's in the 200+ that were
listed.

This also makes all the platforms the same now - external GPIO's are now
exported first (0..x) which is better in the long term for userspace.

The names is a bit of a problem, but I will try my best. We have limited
datasheets etc from the vendor, so knowing what things do is a bit of a
mystery sometimes.

Regards
Tony P

