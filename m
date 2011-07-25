Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1GYNSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:18:40 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39158 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1GYNSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110725140610.47fdda27@lxorguk.ukuu.org.uk>
References: <CAPweEDwVhaHr=5i8giGCkDWxK9G8Vvibq59vhbu6RsnZf9uerA@mail.gmail.com>
	<20110725131701.112e635e@lxorguk.ukuu.org.uk>
	<CAPweEDzQXUTtAwiU4qEB_eQqNgJeazpeTxixyAnbgscvC5yujQ@mail.gmail.com>
	<20110725140610.47fdda27@lxorguk.ukuu.org.uk>
Date: Mon, 25 Jul 2011 14:18:38 +0100
X-Google-Sender-Auth: BTmWBHYN2bH-s4LfNq1hHhbHf_0
Message-ID: <CAPweEDwfmYH0DrsySGFAAxAXdyVrEJUmQvxASQ=OQAJOociddg@mail.gmail.com>
Subject: Re: dynamic LCD support for "embedded" systems
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: debian-arm@lists.debian.org, linux-kernel@vger.kernel.org,
        Wookey <wookey@wookware.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 2:06 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> DVI monitor), and that EDID data just gets passed-through via the VGA
>> IC. so it's all the same stuff... so what's the damn difference
>> between a system with a VGA monitor and a system with the exact same
>> LCD panel *from* that VGA monitor, ehn? :)  ok, rhetorical question.
>
> I'm not convinced it is the same stuff for various reaosns and bits of
> historical bug fixing and observation.

 yehhs... and arnaud's post also provides some more background, which
includes in some cases intermediate ICs that trash / strip out the
required info.  classic...

 http://lists.debian.org/debian-arm/2011/07/msg00054.html

>>  devicetree LCD modules.  these could still be dynamically loaded,
>> right?  i mean, it's a bit crazy, but you could have associated with a
>> particular LCD panel a devicetree-compliant dynamic loaded module
>> which had the correct LCD settings (including the required pre-tested
>> hsync and vsync data), right?
>
> In theory, or passed to the kernel at boot.

 he-he that's not user-friendly, alain :)  the context is a
mass-produced device.

> The obvious long term path I
> would have thought would have been to move to 'device tree if data present
> else...' in the various panel drivers. That way there are no sudden bumps
> in the road for distributors but a device tree data set from any source
> would trump the data extracted by other means.

 ok.  right.  whew.  a migration path.  thank god for that.  no
terrifying all-convert-to-devicetree-or-die approach, then.  shaaame
:)

 l.
