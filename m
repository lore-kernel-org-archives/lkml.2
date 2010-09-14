Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0INOAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:00:10 -0400
Received: from atl.turmel.org ([74.117.157.138]:52970 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab0INOAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:00:07 -0400
Message-ID: <4C8F7FDF.6090904@turmel.org>
Date: Tue, 14 Sep 2010 09:59:59 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Francisco Jerez <currojerez@riseup.net>
CC: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, David Airlie <airlied@linux.ie>,
        =?ISO-8859-1?Q?Marcin_Kos=27cielnicki?= <koriakin@0x04.net>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] nouveau build regression, undefined reference to `acpi_video_get_edid'
References: <4C89ABC3.8080701@turmel.org> <87hbhslatm.fsf@riseup.net>
In-Reply-To: <87hbhslatm.fsf@riseup.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francisco Jerez wrote:
> Phil Turmel <philip@turmel.org> writes:

[snip /]

>> Having the nouveau ACPI features depend on CONFIG_ACPI_VIDEO instead of
>> bare CONFIG_ACPI builds, boots, and works for me.

> nouveau_acpi_edid() is the only function that depends on ACPI_VIDEO,
> ifdef'ing out the rest of the ACPI stuff in that case doesn't make much
> sense to me.

Understood.  I noticed that DRM_I915 does a "select ACPI_VIDEO if ACPI",
which is why I mentioned that alternative below.  I don't recall how I got
the y+m combination above (I tend to build stuff in), but a randconfig
could certainly hit this.  I intend to leave it y+y when I'm done.

>> Presumably, this could also be solved by adding
>> "select ACPI_VIDEO if ACPI" to the nouveau Kconfig.
>> I'd be happy to try that, if this approach is flawed.

I'll test the Kconfig approach later today.

Regards,

Phil Turmel
