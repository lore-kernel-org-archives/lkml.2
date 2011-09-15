Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346Ab1IOSEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:04:33 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42345 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934277Ab1IOSEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:04:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUoYi5xTQz=v1rCycS23vFgQzeZFbNZGnrRN+qkBCrSRA@mail.gmail.com>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<CAMuHMdUoYi5xTQz=v1rCycS23vFgQzeZFbNZGnrRN+qkBCrSRA@mail.gmail.com>
Date: Thu, 15 Sep 2011 14:04:31 -0400
Message-ID: <CADnq5_P+Ubou_geK3Hc8XAkZ4FkyyCib0DJmrzaxfUfH7Oub8g@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Alex Deucher <alexdeucher@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Keith Packard <keithp@keithp.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
        "Clark, Rob" <rob@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 1:56 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Sep 15, 2011 at 19:52, Alex Deucher <alexdeucher@gmail.com> wrote:
>> While the DRM has historically targeted 3D acceleration, that is not a
>> requirement to use the DRM KMS modesetting API.  The current fb API
>> has no concept of display controllers or connectors or overlays, etc.
>> To match it to modern hardware, it needs a major overhaul.  Why create
>> a new modern fb interface that's largely the same as DRM KMS?  What if
>> we just consider the KMS API as the new fb API?  If there are any
>> inadequacies in the DRM KMS API we would be happy to work out any
>> changes.
>
> I admit I didn't look for it, but does there exist a sample DRM KMS driver
> for dumb frame buffer hardware with one fixed video mode?

Not at the moment.  However, there drivers for AMD, Intel, and nvidia
chips as well patches for a number of ARM SoCs that are in the process
of moving upstream.  Also, Matt Turner wrote a KMS driver for 3D labs
glint hardware that is pretty simple (single display controller,
single DAC, etc.), however it hasn't been merged upstream yet.
http://code.google.com/p/google-summer-of-code-2010-xorg/downloads/detail?name=Matt_Turner.tar.gz&can=2&q=
His kernel git tree was on kernel.org so it's down at the moment,
hence the link to the tarball.

Alex
