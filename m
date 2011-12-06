Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1LFWbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:31:48 -0500
Received: from lvps80-90-199-152.vps.webfusion.co.uk ([80.90.199.152]:51546
	"EHLO lvps80-90-199-152.vps.webfusion.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286Ab1LFWbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:31:46 -0500
Date: Tue, 6 Dec 2011 23:31:09 +0100
From: Baptiste Jonglez <baptiste@jonglez.org>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: joeyli <jlee@suse.com>, Baptiste Jonglez <baptiste@jonglez.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org,
        Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
Subject: Re: [Dual-LVDS Acer Iconia laptop] i915/DRM issue: one screen stays
 off [3.2-rc4+]
Message-ID: <20111206223109.GA1867@archminux>
Mail-Followup-To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
	joeyli <jlee@suse.com>, Baptiste Jonglez <baptiste@jonglez.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org,
	Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
References: <20111204160728.GA27292@archminux>
 <1323054041.6046.79.camel@linux-s257.site>
 <20111206215137.GA20907@archminux>
 <CAN+gG=EaG1h=seuKQa_SF2O033WWn52USh=tjO9F9O55DgH17Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=EaG1h=seuKQa_SF2O033WWn52USh=tjO9F9O55DgH17Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:12:26PM +0100, Benjamin Tissoires wrote:
> Hi Baptiste,

Hi,

> On Tue, Dec 6, 2011 at 22:51, Baptiste Jonglez <baptiste@jonglez.org> wrote:
> > The second screen works fine with the attached patch. It actually is
> > 6 months old but seems to have been lost in the wild...
> 
> You don't have the problem of the second backlight still off?
> On our Iconia, we need to trigger a special DMI command to set it up
> (SDSS, IIRC).

No, with the patch, it worked out-of-the-box.

I can even control the brightness in
`/sys/class/backlight/acpi_video0/brightness' (it affects both
displays at the same time though). But even at 0, it's still perfectly
readable.

Maybe this a bug that got fixed recently? I've actually tried the 3.1
kernel (and then the 3.2-rc4) because I noticed a lot of commits and
improvements in the i915 driver recently.

> > Thanks Benjamin!
> 
> All the credits are from Ajax and somebody else on IRC I don't recall,
> really sorry. Thanks to them.
> 
> Cheers,
> Benjamin.

Regards,
Baptiste
