Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2AEPIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:08:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33665 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab2AEPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:08:36 -0500
Date: Thu, 5 Jan 2012 09:08:32 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Richard =?utf-8?Q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Andrzej Prochyra <andrzej@prochyra.name>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH] Platform: samsung-laptop: add DMI information for
 Samsung N150 Plus
Message-ID: <20120105150832.GA25386@ubuntu-macmini>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>,
	Richard =?utf-8?Q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
	David Herrmann <dh.herrmann@googlemail.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrzej Prochyra <andrzej@prochyra.name>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Zhang, Rui" <rui.zhang@intel.com>
References: <87ty4qdpna.fsf@prochyra.name>
 <20111224142028.GA32171@srcf.ucam.org>
 <CANq1E4S+Sa1BERtR6aNH-ypRo+oJ1fRXkuVa+tREy5qVodv2pw@mail.gmail.com>
 <CAHR064jyubYf5d_KekB8+wqmGXcm8v4Gg9jVt3W9Kx_Ljh++GA@mail.gmail.com>
 <CANq1E4T9LtrBgAxhZAcZZc_gN5yuBm0Yn1ukYiWFvH84hKavBA@mail.gmail.com>
 <4EFC3FA8.6020401@gmail.com>
 <4EFC52F0.1010709@t-online.de>
 <CAHR064hwKj7TvEb=+HWWYYCAwkQ976MQid1PKhJgPqafpPBhwQ@mail.gmail.com>
 <20120104205128.GB22414@thinkpad-t410>
 <CAHR064iOA4Xo2EZVR686qokoVTZUN0sFns7uoOcL9cQD1tWxHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064iOA4Xo2EZVR686qokoVTZUN0sFns7uoOcL9cQD1tWxHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 08:18:07AM +0100, Corentin Chary wrote:
> On Wed, Jan 4, 2012 at 9:51 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> > On Thu, Dec 29, 2011 at 12:49:41PM +0100, Corentin Chary wrote:
> >> And that's ? Because new laptops that use SABI seems to have a working
> >> acpi_video0.
> >> Currently, N1{4,5}* seems to be affected.
> >
> > You can add the NF310 to the list of machines without a working
> > acpi_video0. The disassembled DSDT is attached, and the backlight
> > control methods are a bit puzzling. _BCM seems to only accept values
> > that are multiples of 10, but _BCL returns several values that do not
> > meet this criterion. However, when _BCM is called with any of the values
> > from _BCL, even the ones that aren't multiples of 10, _BQC returns the
> > corresponding value. I must be missing something.
> >
> > At any rate, no matter the value given to _BCM the brightness does not
> > change.
> 
> What is the DMI string for this one ?

NF110/NF210/NF310

> intel_backlight don't work either ?

intel_backlight does work, better than the SABI interface in fact. But
the Xorg driver prefers acpi_video0 to intel_backlight, so having a
working intel_backlight isn't doing much good.
