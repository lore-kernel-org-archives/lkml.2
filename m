Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab2AEHSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:18:10 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48902 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab2AEHSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:18:08 -0500
MIME-Version: 1.0
In-Reply-To: <20120104205128.GB22414@thinkpad-t410>
References: <87ty4ss0z4.fsf@prochyra.name>
	<CAHR064h7a=RQq=p1J+gKpC5_6ow8ChUFFkC39HwtmerHaMksjw@mail.gmail.com>
	<87ty4qdpna.fsf@prochyra.name>
	<20111224142028.GA32171@srcf.ucam.org>
	<CANq1E4S+Sa1BERtR6aNH-ypRo+oJ1fRXkuVa+tREy5qVodv2pw@mail.gmail.com>
	<CAHR064jyubYf5d_KekB8+wqmGXcm8v4Gg9jVt3W9Kx_Ljh++GA@mail.gmail.com>
	<CANq1E4T9LtrBgAxhZAcZZc_gN5yuBm0Yn1ukYiWFvH84hKavBA@mail.gmail.com>
	<4EFC3FA8.6020401@gmail.com>
	<4EFC52F0.1010709@t-online.de>
	<CAHR064hwKj7TvEb=+HWWYYCAwkQ976MQid1PKhJgPqafpPBhwQ@mail.gmail.com>
	<20120104205128.GB22414@thinkpad-t410>
Date: Thu, 5 Jan 2012 08:18:07 +0100
Message-ID: <CAHR064iOA4Xo2EZVR686qokoVTZUN0sFns7uoOcL9cQD1tWxHQ@mail.gmail.com>
Subject: Re: [PATCH] Platform: samsung-laptop: add DMI information for Samsung
 N150 Plus
From: Corentin Chary <corentin.chary@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>,
        =?UTF-8?Q?Richard_Sch=C3=BCtz?= <r.schtz@t-online.de>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Andrzej Prochyra <andrzej@prochyra.name>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 9:51 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Thu, Dec 29, 2011 at 12:49:41PM +0100, Corentin Chary wrote:
>> And that's ? Because new laptops that use SABI seems to have a working
>> acpi_video0.
>> Currently, N1{4,5}* seems to be affected.
>
> You can add the NF310 to the list of machines without a working
> acpi_video0. The disassembled DSDT is attached, and the backlight
> control methods are a bit puzzling. _BCM seems to only accept values
> that are multiples of 10, but _BCL returns several values that do not
> meet this criterion. However, when _BCM is called with any of the values
> from _BCL, even the ones that aren't multiples of 10, _BQC returns the
> corresponding value. I must be missing something.
>
> At any rate, no matter the value given to _BCM the brightness does not
> change.

What is the DMI string for this one ?
intel_backlight don't work either ?
-- 
Corentin Chary
http://xf.iksaif.net
