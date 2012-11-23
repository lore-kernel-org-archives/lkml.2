Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2KWRNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:13:25 -0500
Received: from mta-2.ms.rz.rwth-aachen.de ([134.130.7.73]:41102 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689Ab2KWRNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:13:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
X-IronPort-AV: E=Sophos;i="4.83,307,1352070000";   d="scan'208";a="200835247"
Date: Fri, 23 Nov 2012 18:13:25 +0100
From: Helmut Jarausch <jarausch@igpm.rwth-aachen.de>
Subject: Re: nouveau driver fails to build
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
References: <1353681769.29421.0@numa-i>
 <1353684679.1420.7.camel@x61.thuisdomein>
In-reply-to: <1353684679.1420.7.camel@x61.thuisdomein>
X-Mailer: Balsa 2.4.91
Message-id: <1353690805.30841.0@numa-i>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 04:31:19 PM, Paul Bolle wrote:
> On Fri, 2012-11-23 at 15:42 +0100, Helmut Jarausch wrote:
> > with 3.7_rc6 and
> >
> > CONFIG_ACPI_VIDEO=m
> > CONFIG_DRM=y
> > CONFIG_DRM_KMS_HELPER=y
> > CONFIG_DRM_TTM=y
> > CONFIG_DRM_NOUVEAU=y
> > CONFIG_NOUVEAU_DEBUG=5
> > CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> > CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> >
> > with/ without
> > CONFIG_DRM_LOAD_EDID_FIRMWARE=y
> >
> >
> > The kernel fails to build with
> > drivers/built-in.o: In function `nouveau_acpi_edid':
> > (.text+0x12bf21): undefined reference to `acpi_video_get_edid'
> >
> >
> > What am I missing?
> 
> I'd guess it should build (at least without this error) with
> CONFIG_ACPI_VIDEO=y. Is that correct?

Yes, but this is very unnatural.

To get CONFIG_ACPI_VIDEO=y  I need to have VIDEO_OUTPUT_CONTROL=y
for which I have to select the Intel GMA500 Stub Driver although I don't
have such a device and therefore don't need that driver.
Furthermore, I had to chase through quite some flags to find this.

If it's not a bug, it's surprising, at least.

Thanks,
Helmut.

