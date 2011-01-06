Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1AFAcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:32:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51641 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab1AFAcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IlkujQTe/sf7eUho507JbeeeKPhdkd3DCPGDesrTqa63r3EfH5X5RGGQ2CRf/SARni
         nr7MZkUn/vEYHHAQd6BzIgLHHA2/swbbKtpdOvYt8vjylGxw2gXsT0yzjWmGgv6W4Skb
         buDR7lFJ5TAZ7UJ9JpCiGC+hnQImjw4ORugmk=
MIME-Version: 1.0
In-Reply-To: <1294272284.3044.4.camel@localhost>
References: <20110105230323.978508482@clark.site>
	<1294271346.3044.2.camel@localhost>
	<20110105235621.GA22850@suse.de>
	<1294272284.3044.4.camel@localhost>
Date: Wed, 5 Jan 2011 19:32:29 -0500
Message-ID: <AANLkTimCANEZKzMDwRGgToiXetpZp1mv2DkVPgZ7e7pX@mail.gmail.com>
Subject: Re: [Stable-review] [06/49] drm/kms: remove spaces from connector
 names (v2)
From: Alex Deucher <alexdeucher@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        Sergej Pupykin <ml@sergej.pp.ru>, Dave Airlie <airlied@redhat.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 7:04 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Wed, 2011-01-05 at 15:56 -0800, Greg KH wrote:
>> On Wed, Jan 05, 2011 at 11:49:05PM +0000, Ben Hutchings wrote:
>> > On Wed, 2011-01-05 at 15:00 -0800, Greg KH wrote:
>> > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
>> > >
>> > > ------------------
>> > >
>> > > From: Alex Deucher <alexdeucher@gmail.com>
>> > >
>> > > commit e76116ca9671e2e5239054a40303b94feab585ad upstream.
>> > >
>> > > Grub doesn't parse spaces in parameters correctly, so
>> > > this makes it impossible to force video= parameters
>> > > for kms on the grub kernel command line.
>> > >
>> > > v2: shorten the names to make them easier to type.
>> > [...]
>> > > --- a/drivers/gpu/drm/drm_crtc.c
>> > > +++ b/drivers/gpu/drm/drm_crtc.c
>> > > @@ -144,10 +144,10 @@ static struct drm_conn_prop_enum_list dr
>> > >   { DRM_MODE_CONNECTOR_SVIDEO, "SVIDEO", 0 },
>> > >   { DRM_MODE_CONNECTOR_LVDS, "LVDS", 0 },
>> > >   { DRM_MODE_CONNECTOR_Component, "Component", 0 },
>> > > - { DRM_MODE_CONNECTOR_9PinDIN, "9-pin DIN", 0 },
>> > > - { DRM_MODE_CONNECTOR_DisplayPort, "DisplayPort", 0 },
>> > > - { DRM_MODE_CONNECTOR_HDMIA, "HDMI Type A", 0 },
>> > > - { DRM_MODE_CONNECTOR_HDMIB, "HDMI Type B", 0 },
>> > > + { DRM_MODE_CONNECTOR_9PinDIN, "DIN", 0 },
>> > > + { DRM_MODE_CONNECTOR_DisplayPort, "DP", 0 },
>> > [...]
>> >
>> > Why change 'DisplayPort', which doesn't have a space in it?  This might
>> > break a previously working kernel command line.
>>
>> That's what happened in Linus's tree, I just mirror it :)
>
> Yeah, sorry, that was really directed at Alex.

We wanted to make them shorter so as to be easier to type on the
command line.  I don't think anyone uses these much at the moment.
Also, you can't force displayport on like other encoders, so if it's
not detected, you are out of luck.

Alex

>
> Ben.
>
> --
> Ben Hutchings
> Once a job is fouled up, anything done to improve it makes it worse.
>
